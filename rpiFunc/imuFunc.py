import time
import board
import busio
import adafruit_bno055


sensor = adafruit_bno055.BNO055_I2C(busio.I2C(board.SCL, board.SDA))


def imuEuler():
    raw = sensor.euler
    x = raw[0]
    y = raw[1]
    z = raw[2]
    return str(y)


def imuTemp():
    raw = sensor.temperature
    output = raw.split(".")[0]
    return raw


#
# class IMU:
#     def __init__(self):
#         self.sensor = adafruit_bno055.BNO055_I2C(busio.I2C(board.SCL, board.SDA))
#     def euler(self):
#         return self.sensor.euler
# while True:
#     print("Temperature: {} degrees C".format(sensor.temperature))
#     print("Accelerometer (m/s^2): {}".format(sensor.acceleration))
#     print("Magnetometer (microteslas): {}".format(sensor.magnetic))
#     print("Gyroscope (rad/sec): {}".format(sensor.gyro))
#     print("Euler angle: {}".format(sensor.euler))
#     print("Quaternion: {}".format(sensor.quaternion))
#     print("Linear acceleration (m/s^2): {}".format(sensor.linear_acceleration))
#     print("Gravity (m/s^2): {}".format(sensor.gravity))
#     print()
#
#     time.sleep(1)
