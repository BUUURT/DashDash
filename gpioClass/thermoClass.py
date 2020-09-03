import time

import Adafruit_GPIO.SPI as SPI
import MAX6675.MAX6675 as MAX6675


# Define a function to convert celsius to fahrenheit.
def c_to_f(c):
        return c * 9.0 / 5.0 + 32.0


# Uncomment one of the blocks of code below to configure your Pi or BBB to use
# software or hardware SPI.

# Raspberry Pi software SPI configuration.
# CLK = 25
# CS  = 24
# DO  = 18
# sensor = MAX6675.MAX6675(CLK, CS, DO)

# Raspberry Pi hardware SPI configuration.
#SPI_PORT   = 0
#SPI_DEVICE = 0
#sensor = MAX6675.MAX6675(spi=SPI.SpiDev(SPI_PORT, SPI_DEVICE))

# BeagleBone Black software SPI configuration.
CLK = 'P9_12'
CS  = 'P9_15'
DO  = 'P9_23'
sensor = MAX6675.MAX6675(CLK, CS, DO) 

# BeagleBone Black hardware SPI configuration.
# SPI_PORT   = 1
# SPI_DEVICE = 0
# sensor = MAX6675.MAX6675(spi=SPI.SpiDev(SPI_PORT, SPI_DEVICE))

# Loop printing measurements every second.
print 'Press Ctrl-C to quit.'
while True:
	temp = sensor.readTempC()
	print 'Thermocouple Temperature: {0:0.3F}°C / {1:0.3F}°F'.format(temp, c_to_f(temp))
	time.sleep(1.0)
