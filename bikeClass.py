import time
import serial

import board
import busio
import RPi.GPIO as GPIO
import adafruit_bno055
import adafruit_gps
import adafruit_max31855
import digitalio


#from multiprocessing import Process

class Bike:
    def __init__(self,gpioPin_ws=17):
        self.laps = 0
        self.distance = 0
        self.speed = 0 #mph
        self.wheel_elapse = time.time() #meta
        self.gpioPin_ws = gpioPin_ws #meta
        self.rpm = 0 #int
        self.Etemp= 0 #degF

        self.airTemp = 0
        self.test = str(time.time())

        GPIO.setmode(GPIO.BCM)
        GPIO.setwarnings(False)
        GPIO.setup(sensor,GPIO.IN,GPIO.PUD_UP)
        GPIO.add_event_detector(self.gpioPin_ws,GPIO.FALLING,callback=surething,bouncetime=20)
        self.sensor = adafruit_bno055.BNO055_I2C(busio.I2C(board.SCL, board.SDA))
        self.airTemp = str(self.sensor.temperature).split('.')[0]
        self.imu_x = self.sensor.euler[0]
        self.imu_y = self.sensor.euler[1]
        self.imu_z = self.sensor.euler[2]

        self.GPIO = GPIO
        self.GPIO.setmode(GPIO.BCM)
        self.GPIO.setwarnings(False)
        self.GPIO.setup(self.gpioPin_ws,GPIO.IN,GPIO.PUD_UP)
        self.GPIO.add_event_detect(self.gpioPin_ws,GPIO.FALLING,callback=self.speedCalc,bouncetime=20)

        self.imu = adafruit_bno055.BNO055_I2C(busio.I2C(board.SCL, board.SDA))
        self.airTemp = int((1.8*self.imu.temperature)+32) #degF
        # self.rotationX = self.sensor.euler[0]
        # self.rotationY = self.sensor.euler[1]
        # self.rotationZ = self.sensor.euler[2]

        #gps
        uart = serial.Serial("/dev/ttyS0", baudrate=9600, timeout=10)


        self.gps = adafruit_gps.GPS(uart, debug=False)
        self.gps.send_command(b"PMTK314,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0")
        self.gps.send_command(b"PMTK220,10000")

        #thermocouple
        self.spi = busio.SPI(board.SCK, MOSI=board.MOSI, MISO=board.MISO)
        self.cs = digitalio.DigitalInOut(board.D5)
        self.max31855 = adafruit_max31855.MAX31855(spi, cs)
        self.EngineTemp = max31855.temperature*9/5+32


    def speedCalc(self,pin):
        #circ = 3140 #mm @ 500mm dia / ~20"
        timeDelta = time.time()-self.wheel_elapse
        self.wheel_elapse = time.time()
        self.speed = (3140/timeDelta)/447.04 # mph/mmps conversion

    def _airTemp(self):
        self.airTemp = int((1.8*self.imu.temperature)+32)
        return self.airTemp


if __name__ == '__main__':
    i = Bike()
    while True:
        print(i.EngineTemp)
        time.sleep(0.5)
        # i.speedCalc()
        # print(i.speed)
        # time.sleep(0.1)
#     #p = Process(target=i.runner())
#     p =Process(target=a)
#     j = Process(target=joy)
#     p.start()
#     j.start()
