import time
import serial
import json
import matplotlib.path as path
import subprocess

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
        _camera=True,
        influxUrl='http://192.168.254.40:8086',
        influxToken="rc0LjEy36DIyrb1CX6rnUDeMJ0-ldW5Mps1KOwkSRrRhbRWDsGzPlNn6BOiyg96vWEKRMZ3xwsfZVgIAxL2gCw==",
        race='test3',
        units='standard'):
        """_args enables sensor type, on by default"""
        #influx config
        self.org = "rammers"
        self.bucket = race
        self.client = InfluxDBClient(url=influxUrl, token=influxToken)
        self.write_api = self.client.write_api(write_options=SYNCHRONOUS)

        self.units = units
        self.unitCalc_temp = lambda x : x*9/5+32 if self.units == 'standard' else x if self.units == "metric"
        self.lap = 0
        self.distance = 0
        self.speed = 0 #mph
        self.rpm = 0 #int
        self.engineTemp= 0
        self.airTemp = 0
        self.rpm_elapse = time.monotonic()
        self.wheel_elapse = time.monotonic()

        #timing

        self.current_sector = 1
        self.lapTime = 0
        self.lastLap = 0
        self.bestLap = 0
        self.sessionTime = time.monotonic()
        self.rider = 'default'
        self.sectorTime = time.monotonic()
        self.mapData = 0
        self.s1Time=0
        self.s2Time=0
        self.s3Time=0

        if _wheelspeed == True or _rpm == True:
            self.GPIO = GPIO
            self.GPIO.setmode(GPIO.BCM)
            self.GPIO.setwarnings(False)

        if _wheelspeed == True:
            self.GPIO.setup(17,GPIO.IN,GPIO.PUD_UP)#fix
            self.GPIO.add_event_detect(17,GPIO.FALLING,callback=self.speedCalc,bouncetime=20)

        if _rpm == True:
            self.GPIO.setup(27,GPIO.IN,GPIO.PUD_UP)#fix
            self.GPIO.add_event_detect(27,GPIO.FALLING,callback=self.rpmCalc,bouncetime=2)

        if _imu == True:#IMU
            self.imu = adafruit_bno055.BNO055_I2C(busio.I2C(board.SCL, board.SDA))
            self.airTemp = lambda : round(self.unitCalc_temp(self.imu.temperature) #*9/5+32 if self.units == 'standard' else self.max31855.temperature,0)
            # self.euler = str(self.imu.euler).replace(' ','')
            # self.acceleration = str(self.imu.acceleration).replace(' ','')
            self.rotationX = lambda : round(self.imu.euler[0],6) if self.imu.euler != None else False
            self.rotationY = lambda : round(self.imu.euler[1],6) if self.imu.euler != None else False
            self.rotationZ = lambda : round(self.imu.euler[2],6) if self.imu.euler != None else False
            self.accelX = lambda : round(self.imu.acceleration[0],6) if self.imu.accelerationr != None else False
            self.accelY = lambda : round(self.imu.acceleration[1],6) if self.imu.acceleration != None else False
            self.accelZ = lambda : round(self.imu.acceleration[2],6) if self.imu.acceleration != None else False

        if _gps == True:
            uart = serial.Serial("/dev/ttyS0", baudrate=9600, timeout=10)
            self.gps = adafruit_gps.GPS(uart, debug=False)
            self.gps.send_command(b"PMTK314,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0")
            self.gps.send_command(b"PMTK220,10000")
            self.lat = lambda : self.gps.latitude if self.gps.latitude!= None else False
            self.long = lambda : self.gps.longitude if self.gps.longitude!= None else False
            # self.long = False
            # if self.gps.latitude != None:
            #     # self.lat = lambda : self.gps.latitude
            # if self.gps.longitude != None:
            #     self.long = lambda : self.gps.longitude

        if _engTemp == True: #thermocouple
            self.spi = busio.SPI(board.SCK, MOSI=board.MOSI, MISO=board.MISO)
            self.cs = digitalio.DigitalInOut(board.D5)
            self.max31855 = adafruit_max31855.MAX31855(self.spi, self.cs)
            self.engineTemp = lambda : round(self.unitCalc_temp(self.max31855.temperature),0)

        # if _camera == True:
        #     subprocess.run(['camera_startup'])
        #     #1280 x 720

    def speedCalc(self,channel):
        #circ = 3140 #mm @ 500mm dia / ~20"
        timeDelta = time.monotonic()-self.wheel_elapse
        self.wheel_elapse = time.monotonic()
        if self.units == 'standard':
            self.speed = round(7.023979/timeDelta,2) # mph/mmps conversion
        if self.units == 'metric':
            self.speed = round(timeDelta/277.778,2) # mmps to kmh
        # return self.speed

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
            "speed" : self.speed,
            "rpm" : self.rpm,
            #brake :
            "engTemp" : self.engineTemp(),
            "airTemp" : self.airTemp(),
            "gps_lat" : self.long(),
            "gps_long" : self.lat(),
            "rotationX" : self.rotationX(),
            "rotationY" : self.rotationY(),
            "rotationZ" : self.rotationZ(),
            "accelX" : self.accelX(),
            "accelY" : self.accelY(),
            "accelZ" : self.accelZ(),
            # "laptime" : self.lapTime,
            # "s1Time" : self.s1Time,
            # "s2Time" : self.s2Time,
            # "s3Time" : self.s3Time
            }


            # self.rotationX = self.imu.euler[0]
            # self.rotationY = self.imu.euler[1]
            # self.rotationZ = self.imu.euler[2]
            # self.accelX = self.imu.acceleration[0]
            # self.accelY = self.imu.acceleration[1]
            # self.accelZ = self.imu.acceleration[2]

        sensorList = [f"{k}={v}" for k,v in sensorDict.items()]
        data = f'rammerRpi,lap={self.lap} {",".join(sensorList)} {str(time.time()).replace(".","")+"0"}'

        self.write_api.write(self.bucket,self.org, data)
        # write_api.write(bucket, org, f"grower,bike=computer cycle3={i} {str(time.time()).replace('.','')+'0'}")
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
