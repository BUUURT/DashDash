import serial
import time
import json
import matplotlib.path as path
import subprocess
import threading

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
# camera
# timeout for speed and rpm
# lap timing / sector timing
## ui config vs whatever


class Bike:
    def __init__(
        self,
        debug=False,
        _wheelspeed=True,
        _rpm=True,
        _gps=True,
        _imu=True,
        _engTemp=True,
        _camera=True,
        influxUrl="http://192.168.254.40:8086",
        influxToken="rc0LjEy36DIyrb1CX6rnUDeMJ0-ldW5Mps1KOwkSRrRhbRWDsGzPlNn6BOiyg96vWEKRMZ3xwsfZVgIAxL2gCw==",
        race="test5",
        units="standard",
    ):
        """_args enables sensor type, on by default"""
        # influx config
        self.org = "rammers"
        self.bucket = race
        self.client = InfluxDBClient(url=influxUrl, token=influxToken)
        self.write_api = self.client.write_api(write_options=SYNCHRONOUS)

        self.units = units
        # self.unitCalc_temp = lambda x : x*9/5+32 if self.units == 'standard' else x
        self.lap = 0
        self.distance = 0
        self.speed = 0  # mph
        self.rpm = 0  # int
        self.engineTemp = 0
        self.airTemp = 0
        self.rpm_elapse = time.monotonic()
        self.wheel_elapse = time.monotonic()

        # timing
        self.current_sector = 1
        self.lapTime = 0
        self.lastLap = 0
        self.bestLap = 0
        self.sessionTime = time.monotonic()
        self.rider = "default"
        self.sectorTime = time.monotonic()
        self.mapData = 0
        self.s1Time = 0
        self.s2Time = 0
        self.s3Time = 0

        # if debug == True:
        #     _wheelspeed = False
        #     _rpm=True
        #     _gps=True
        #     _imu=True
        #     _engTemp=True
        #     _camera=True

        if _wheelspeed == True or _rpm == True:
            self.GPIO = GPIO
            self.GPIO.setmode(GPIO.BCM)
            self.GPIO.setwarnings(False)

        if _wheelspeed == True:
            # self.GPIO.setup(17, GPIO.IN, GPIO.PUD_DOWN)
            self.GPIO.setup(17, GPIO.IN, GPIO.PUD_UP)
            self.GPIO.add_event_detect(
                17, GPIO.FALLING, callback=self.speedCalc, bouncetime=20
            )

        if _rpm == True:
            self.GPIO.setup(27, GPIO.IN, GPIO.PUD_DOWN)
            self.GPIO.add_event_detect(
                27, GPIO.RISING, callback=self.rpmCalc, bouncetime=2
            )

        if _imu == True:  # IMU
            self.imu = adafruit_bno055.BNO055_I2C(busio.I2C(board.SCL, board.SDA))

        if _gps == True:
            uart = serial.Serial("/dev/ttyS0", baudrate=9600, timeout=10)
            self.gps = adafruit_gps.GPS(uart, debug=False)
            self.gps.send_command(b"PMTK314,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0")
            self.gps.send_command(b"PMTK220,10000")

        if _engTemp == True:  # thermocouple
            self.spi = busio.SPI(board.SCK, MOSI=board.MOSI, MISO=board.MISO)
            self.cs = digitalio.DigitalInOut(board.D5)
            self.max31855 = adafruit_max31855.MAX31855(self.spi, self.cs)

        self.sensorDict = dict()
        self.sensorThread = threading.Thread(target=self.call_sensorDict)
        self.sensorThread.start()

        # self.influxThread = threading.Thread(target=self.influxUpdate, args=(self.sensorDict,))
        # self.influxThread.start()

    def call_engTemp(self):
        try:
            i = self.max31855.temperature
            if self.units == "standard":
                i = i * 9 / 5 + 32
            engineTemp = round(i, 0)
        except:
            engineTemp = 0
        return engineTemp

    def call_gps(self):
        try:
            x = self.gps.latitude
            y = self.gps.longitude
            if x == None:
                x = False
            if y == None:
                y = False
        except:
            x = False
            y = False
        return (x, y)

    def call_imu(self):
        try:
            airTemp = (
                round(self.imu.temperature * 9 / 5 + 32, 0)
                if self.units == "standard"
                else round(self.imu.temperature, 0)
            )
            rotX = round(self.imu.euler[0], 6)
            rotY = round(self.imu.euler[1], 6)
            rotZ = round(self.imu.euler[2], 6)
            accelX = round(self.imu.acceleration[0], 6)
            accelY = round(self.imu.acceleration[1], 6)
            accelZ = round(self.imu.acceleration[2], 6)
        except:
            airTemp = 0
            rotX = 0
            rotY = 0
            rotZ = 0
            accelX = 0
            accelY = 0
            accelZ = 0
        return {
            "airTemp": airTemp,
            "rotX": rotX,
            "rotY": rotY,
            "rotZ": rotZ,
            "accelX": accelX,
            "accelY": accelY,
            "accelZ": accelZ,
        }

    def speedCalc(self, channel):
        # circ = 3140 #mm @ 500mm dia / ~20"
        wheelTimeDelta = time.monotonic() - self.wheel_elapse
        self.wheel_elapse = time.monotonic()
        if self.units == "standard":
            self.speed = round(7.023979 / wheelTimeDelta, 2)  # mph/mmps conversion
        if self.units == "metric":
            self.speed = round(wheelTimeDelta / 277.778, 2)  # mmps to kmh
        # return self.speed

    def rpmCalc(self, channel):
        rpmTimeDelta = time.monotonic() - self.rpm_elapse
        self.rpm_elapse = time.monotonic()
        self.rpm = int(60 / rpmTimeDelta)  # 1rev/pulse  conversion
        # return self.rpm

    def setTrack(self, track="tckc"):
        with open("tracklist.json") as trackList:
            data = json.load(trackList)
            s1 = path(data[track]["s1"])
            s2 = path(data[track]["s2"])
            s3 = path(data[track]["s3"])
            self.mapData = {1: s1, 2: s2, 3: s3}

    def sectorTime(self):
        """get new GPS location then evaluate for sector change.  Updates timing values upon sector change"""
        if self.mapData == None:
            return "set track"
        self.gps.update()
        self.location = [(self.gps.latitude, self.gps.longitude)]

        sectorindex = {1: 2, 2: 3, 3: 1}
        nextsector = sectorindex[self.current_sector]
        if self.mapData[nextsector].contains(self.location)[0]:
            oldTime = time.monotonic() - self.sectorTime
            self.sectorTime = time.monotonic()
            self.current_sector = nextsector

            if nextsector == 1:
                self.lap += 1
                tDelta = self.lastLap
                self.lastLap = time.monotonic() - self.lapTime
                self.lapTime = time.monotonic()
                self.lapDelta = pyth
                if self.lastLap < self.bestLap:
                    self.bestlap = self.lastlap

    def call_sensorDict(self):
        while True:
            lap = self.lap
            gpsTup = self.call_gps()
            imuDict = self.call_imu()

            self.sensorDict = {
                "speed": self.speed,
                "rpm": self.rpm,
                # brake :
                "engTemp": self.call_engTemp(),
                "airTemp": imuDict["airTemp"],
                "gps_lat": gpsTup[0],
                "gps_long": gpsTup[1],
                "rotationX": imuDict["rotX"],
                "rotationY": imuDict["rotX"],
                "rotationZ": imuDict["rotZ"],
                "accelX": imuDict["accelX"],
                "accelY": imuDict["accelY"],
                "accelZ": imuDict["accelZ"]
                # "laptime" : self.lapTime,
                # "s1Time" : self.s1Time,
                # "s2Time" : self.s2Time,
                # "s3Time" : self.s3Time
            }

            # try:
            #     sensorList = [f"{k}={v}" for k,v in self.sensorDict.items()]
            #     data = f'rammerRpi,lap={self.lap} {",".join(sensorList)}'#{str(time.time()).replace(".","")+"0"}'
            #     self.write_api.write(self.bucket,self.org, data)
            #
            # except:
            #     print('influx error')
            time.sleep(0.016)

    def messageRefresh(self):
        pass


if __name__ == "__main__":
    i = Bike()
    # while True:
    # print(i.EngineTemp)
    # time.sleep(0.5)
    # i.speedCalc()
    # print(i.speed)
    # time.sleep(0.1)
#     #p = Process(target=i.runner())
#     p =Process(target=a)
#     j = Process(target=joy)
#     p.start()
#     j.start()
