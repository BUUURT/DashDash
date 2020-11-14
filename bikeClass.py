import time
import RPi.GPIO as GPIO
import board
import busio
import adafruit_bno055

#from multiprocessing import Process

import pandas
#
class Bike:
    def __init__(self,gpioPin_ws=17):
        self.laps = 0
        self.distance = 0
        self.speed = 0 #mph
        self.wheel_elapse = time.time()
        self.gpioPin_ws = gpioPin_ws
        self.rpm = 0
        self.Etemp= 0 #degF
        self.airTemp = 0

        self.GPIO.setmode(GPIO.BCM)
        self.GPIO.setwarnings(False)
        self.GPIO.setup(self.gpioPin_ws,GPIO.IN,GPIO.PUD_UP)
        self.GPIO.add_event_detector(self.gpioPin_ws,GPIO.FALLING,callback=surething,bouncetime=20)

        # self.sensor = adafruit_bno055.BNO055_I2C(busio.I2C(board.SCL, board.SDA))
        # self.airTemp = str(self.sensor.temperature).split('.')[0]
        # self.imu_x = self.sensor.euler[0]
        # self.imu_y = self.sensor.euler[1]
        # self.imu_z = self.sensor.euler[2]


    def speedCalc(self):
        #circ = 3140 #mm @ 500mm dia / ~20"
        timeDelta = time.time()-self.wheel_elapse
        self.wheel_elapse = time.time()
        self.speed = (3140/timeDelta)/447.04 # mph/mmps conversion









if __name__=='__main__':
    i = Bike(4)

#
#     def __str__(self):
#         return self.value
#     def __repr__(self):
#         return self.value
# def a():
#     i = 0
#     while True:
#         i +=1
#         print(i)
#
#
#
# def joy():
#     while True:
#         print('JOY')
#         time.sleep(1)
#
#
# if __name__ == '__main__':
#     i = Bike(6)
#     #p = Process(target=i.runner())
#     p =Process(target=a)
#     j = Process(target=joy)
#     p.start()
#     j.start()
