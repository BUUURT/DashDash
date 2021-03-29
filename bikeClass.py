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

### to do ###
# test all ports at once
# test return of class attrs; func or attr call
# gps mapping

#

#from multiprocessing import Process

class Bike:
    def __init__(self,):
        self.laps = 0
        self.distance = 0
        self.speed = 0 #mph
        self.wheel_elapse = time.time() #meta
        self.rpm = 0 #int
        self.Etemp= 0 #degF
        # self.airTemp = int((1.8*self.imu.temperature)+32)

        #timing

        self.current_sector = 1
        self.lapTime = time.monotonic()
        self.lastLap = None
        self.bestLap = None

        self.sectorTime = time.monotonic()
        self.mapData = None
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

        #bench testing
        self.test = str(time.time())

        # GPIO.setmode(GPIO.BCM)
        # GPIO.setup(17,GPIO.IN,GPIO.PUD_UP)#wheelspeed
        # GPIO.setup(27,GPIO.IN,GPIO.PUD_UP)#wheelspeed
        # GPIO.setwarnings(False)
        # GPIO.add_event_detector(17,GPIO.FALLING,callback=surething,bouncetime=20)
        # GPIO.add_event_detector(27,GPIO.FALLING,callback=surething,bouncetime=20)


        self.GPIO = GPIO
        self.GPIO.setmode(GPIO.BCM)
        self.GPIO.setwarnings(False)
        #wheel speed
        # self.GPIO.setup(17,GPIO.IN,GPIO.PUD_UP)#fix
        # self.GPIO.add_event_detect(17,GPIO.FALLING,callback=self.speedCalc,bouncetime=20)
        #rpm
        # self.GPIO.setup(27,GPIO.IN,GPIO.PUD_UP)#fix
        # self.GPIO.add_event_detect(27,GPIO.FALLING,callback=self.rpmCalc,bouncetime=20)

        #IMU
        # self.imu = adafruit_bno055.BNO055_I2C(busio.I2C(board.SCL, board.SDA))
        self.airTemp = int((1.8*self.imu.temperature)+32) #degF
        self.rotationX = self.sensor.euler[0]
        self.rotationY = self.sensor.euler[1]
        self.rotationZ = self.sensor.euler[2]

        #gps
        # uart = serial.Serial("/dev/ttyS0", baudrate=9600, timeout=10)
        # self.gps = adafruit_gps.GPS(uart, debug=False)
        # self.gps.send_command(b"PMTK314,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0")
        # self.gps.send_command(b"PMTK220,10000")

        #thermocouple
        # self.spi = busio.SPI(board.SCK, MOSI=board.MOSI, MISO=board.MISO)
        # self.cs = digitalio.DigitalInOut(board.D5)
        # self.max31855 = adafruit_max31855.MAX31855(spi, cs)
        # self.EngineTemp = max31855.temperature*9/5+32

    def speedCalc(self):
        #circ = 3140 #mm @ 500mm dia / ~20"
        timeDelta = time.monotonic()-self.wheel_elapse
        self.wheel_elapse = time.monotonic()
        self.speed = (3140/timeDelta)/447.04 # mph/mmps conversion
        return self.speed

    def rpmCalc(self):
        #circ = 3140 #mm @ 500mm dia / ~20"
        timeDelta = time.monotonic()-self.rpm_elapse
        self.rpm_elapse = time.monotonic()
        self.rpm_elapse = int(60/timeDelta) # 1rev/mmps conversion
        return self.rpm

    def airTemp(self):
        self.airTemp = int((1.8*self.imu.temperature)+32)
        return self.airTemp

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

        location = [(self.gps.latitude,self.gps.longitude)]

        sectorindex = {1:2,2:3,3:1}
        nextsector = sectorindex[self.current_sector]
        if self.mapData[nextsector].contains(location)[0]:
            secTimeFinal = time.monotonic()-self.sectorTime
            self.sectorTime = time.monotonic()
            self.current_sector = nextsector


            if nextsector == 1:
                self.lap += 1
                self.lastLap = time.monotonic()- self.lapTime
                self.lapTime = time.monotonic()
                if self.lastLap<self.bestLap:
                    self.bestlap = self.lastlap



        # if self.sector == 1:
        #     sectorTime = time.monotonic()-self.s1_time
        #     if self.map_s2.contains_points(location)[0] == True:
        #         self.s1_time = sectorTime
        #         self.sector = 2
        #         self.s2_time = time.monotonic()
        #     return (self.s1_time, none)
        #
        # if self.sector == 2:
        #     if self.map_s3.contains_points(location)[0] == True:
        #         self.s2_time = time.monotonic()-self.s2_time
        #         self.sector = 3
        #         self.s3_time = time.monotonic()
        #         return (self.s2_time, none)
        #
        # if self.sector == 3:
        #     if self.map_s1.contains_points(location)[0] == True:
        #         self.s3_time = time.monotonic()-self.s3_time
        #         self.laptime
        #         self.sector = 3
        #         self.s3_time = time.monotonic()
        #         return (self.s3_time, self.lapTime)





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
