import adafruit_bno055

from busio import I2C
from board import SDA, SCL

class Imu:
    def __init__(self):
        i2c=I2C(SCL,SDA)
        self.imuboard = adafruit+bno055.BNO055(i2c)
    def __str__(self):
        print(self.imuboard.temperature)


i=Imu()
# def imu_read():
#     i2c = I2C(SCL, SDA)
#     imuBoard = adafruit_bno055.BNO055(i2c)
#     print(imuBoard).temperature
