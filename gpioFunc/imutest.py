import adafruit_bno055

from busio import I2C
from board import SDA, SCL

i2c = I2C(SCL, SDA)

imuBoard = adafruit_bno055.BNO055(i2c)

print(imuBoard).temperature
