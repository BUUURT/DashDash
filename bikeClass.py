import time
import serial
import json
import matplotlib.path as path

import board
import busio
import RPi.GPIO as GPIO
import adafruit_bno055
import adafruit_gps
import adafruit_max31855
import digitalio

from influxdb_client import InfluxDBClient, Point, WritePrecision
from influxdb_client.client.write_api import SYNCHRONOUS

### to do ###
# test all ports at once

# influx output wrapup
 # lap timing / sector timing tuple

##from multiprocessing import Process

class Bike:
    def __init__(self,
        _wheelspeed=True,
        _rpm=True,
        _gps=True,
        _imu=True,
        _engTemp=True,
        influxUrl='http://192.168.254.40:8086',
        influxToken="JsGcGk3NLpEAN4NEQy7piJCL4fGVSBOSsPBKHWkLkP8DKlz6slQh9TFoC5VBwuHkMoDWFvrnOP1t90TTPdRfuA==",
        race='test3',
        units='standard'):
        """_args enables sensor type, on by default"""
        #influx config
        self.org = "rammers"
        self.bucket = race
        self.client = InfluxDBClient(url=influxUrl, token=influxToken)
        self.write_api = self.client.write_api(write_options=SYNCHRONOUS)

        self.units = units
        self.lap = 0
        self.distance = 0
        self.speed = 0 #mph
        self.rpm = 0 #int
        self.engineTemp= 0
        self.airTemp = 0
        self.rpm_elapse = time.monotonic()
        self.wheel_elapse = time.monotonic() #meta


        #timing

        self.current_sector = 1
        self.lapTime = time.monotonic()
        self.lastLap = None
        self.bestLap = None

        self.sectorTime = time.monotonic()
        self.mapData = None
        self.s1Time=0
        self.s2Time=0
        self.s3Time=0
        #
        # self.s1_last = None
        # self.s1_time = time.monotonic()
        #
        # self.s2_last = None
        # self.s2_time = None
        #
        # self.s3_last = None
        # self.s3_time = None
        #
        # self.map_s1 = None
        # self.map_s2 = None
        # self.map_s3 = None

        #old??
        # if wheelspeed == True:
        #     self.GPIO.setmode(GPIO.BCM)
        #     self.GPIO.setup(17,GPIO.IN,GPIO.PUD_UP)#wheelspeed
        #     self.GPIO.setwarnings(False)
        # GPIO.setup(27,GPIO.IN,GPIO.PUD_UP)#wheelspeed
        # GPIO.setwarnings(False)
        # GPIO.add_event_detector(17,GPIO.FALLING,callback=surething,bouncetime=20)
        # GPIO.add_event_detector(27,GPIO.FALLING,callback=surething,bouncetime=20)

        if _wheelspeed == True or _rpm == True:
            self.GPIO = GPIO
            self.GPIO.setmode(GPIO.BCM)
            self.GPIO.setwarnings(False)

        if _wheelspeed == True:
            self.GPIO.setup(17,GPIO.IN,GPIO.PUD_UP)#fix
            self.GPIO.add_event_detect(17,GPIO.FALLING,callback=self.speedCalc,bouncetime=20)

        if _rpm == True:
            self.GPIO.setup(27,GPIO.IN,GPIO.PUD_UP)#fix
            self.GPIO.add_event_detect(27,GPIO.FALLING,callback=self.rpmCalc,bouncetime=20)

        if _imu == True:#IMU
            self.imu = adafruit_bno055.BNO055_I2C(busio.I2C(board.SCL, board.SDA))
            self.airTemp = lambda x: self.max31855.temperature*9/5+32 if self.units == 'standard' else self.max31855.temperature
            # self.rotationX = self.imu.euler[0]
            # self.rotationY = self.imu.euler[1]
            # self.rotationZ = self.imu.euler[2]

        if _gps == True:
            uart = serial.Serial("/dev/ttyS0", baudrate=9600, timeout=10)
            self.gps = adafruit_gps.GPS(uart, debug=False)
            self.gps.send_command(b"PMTK314,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0")
            self.gps.send_command(b"PMTK220,10000")

        if _engTemp == True: #thermocouple
            self.spi = busio.SPI(board.SCK, MOSI=board.MOSI, MISO=board.MISO)
            self.cs = digitalio.DigitalInOut(board.D5)
            self.max31855 = adafruit_max31855.MAX31855(self.spi, self.cs)
            self.engineTemp = lambda : self.max31855.temperature*9/5+32 if self.units == 'standard' else self.max31855.temperature

    def speedCalc(self):
        #circ = 3140 #mm @ 500mm dia / ~20"
        timeDelta = time.monotonic()-self.wheel_elapse
        self.wheel_elapse = time.monotonic()
        if self.units == 'standard':
            self.speed = (3140/timeDelta)/447.04 # mph/mmps conversion
        if self.units == 'metric':
            self.speed = timeDelta/277.778 # mmps to kmh
        return self.speed

    def rpmCalc(self):
        #circ = 3140 #mm @ 500mm dia / ~20"
        timeDelta = time.monotonic()-self.rpm_elapse
        self.rpm_elapse = time.monotonic()
        self.rpm_elapse = int(60/timeDelta) # 1rev/mmps conversion
        return self.rpm

    def setTrack(self,track='tckc'):
        with open('tracklist.json') as trackList:
            data = json.load(trackList)
            s1 = path(data[track]['s1'])
            s2 = path(data[track]['s2'])
            s3 = path(data[track]['s3'])
            self.mapData={1:s1,2:s2,3:s3}

    def sectorTime(self):
        """get new GPS location then evaluate for sector change.  Updates timing values upon sector change"""
        if self.mapData == None:
            return "set track"
        self.gps.update()

        self.location = [(self.gps.latitude,self.gps.longitude)]

        sectorindex = {1:2,2:3,3:1}
        nextsector = sectorindex[self.current_sector]
        if self.mapData[nextsector].contains(self.location)[0]:
            secTimeFinal = time.monotonic()-self.sectorTime
            self.sectorTime = time.monotonic()
            self.current_sector = nextsector

            if nextsector == 1:
                self.lap += 1
                self.lastLap = time.monotonic()- self.lapTime
                self.lapTime = time.monotonic()
                if self.lastLap<self.bestLap:
                    self.bestlap = self.lastlap

    def influxUpdate(self):
        lap = self.lap
        timeStamp = str(time.time()).replace('.','')+'0'

        sensorDict = {
            "speed" : self.speedCalc(),
            "rpm" : self.rpmCalc(),
            #brake :
            "engTemp" : self.engineTemp(),
            "airTemp" : self.airTemp(),
            "gps" : f'{self.gps.latitude},{self.gps.longitude}',
            "euler" : self.imu.euler,
            "accel" : self.imu.acceleration,
            "laptime" : self.lapTime,
            "s1Time" : self.s1Time,
            "s2Time" : self.s2Time,
            "s3Time" : self.s3Time}

        sensorList = [f"{k}={v}" for k,v in sensorDict.items()]
        data = f'rammerRpi,lap={self.lap} {",".join(sensorList)}'
        self.write_api.write(self.bucket,self.org, data)
        return sensorDict

    def messageRefresh(self):
        pass


if __name__ == '__main__':
    i = Bike()
    # while True:
        #print(i.EngineTemp)
        # time.sleep(0.5)
        # i.speedCalc()
        # print(i.speed)
        # time.sleep(0.1)
#     #p = Process(target=i.runner())
#     p =Process(target=a)
#     j = Process(target=joy)
#     p.start()
#     j.start()
