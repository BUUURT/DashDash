#!/usr/bin/env python

# MAX6675.py
# 2016-05-02
# Public Domain

import time
import pigpio # http://abyz.co.uk/rpi/pigpio/python.html

"""
This script reads the temperature of a type K thermocouple
connected to a MAX6675 SPI chip.

Type K thermocouples are made of chromel (+ve) and alumel (-ve)
and are the commonest general purpose thermocouple with a
sensitivity of approximately 41 uV/C.

The MAX6675 returns a 12-bit reading in the range 0 - 4095 with
the units as 0.25 degrees centigrade.  So the reported
temperature range is 0 - 1023.75 C.

Accuracy is about +/- 2 C between 0 - 700 C and +/- 5 C
between 700 - 1000 C.

The MAX6675 returns 16 bits as follows

F   E   D   C   B   A   9   8   7   6   5   4   3   2   1   0
0  B11 B10  B9  B8  B7  B6  B5  B4  B3  B2  B1  B0  0   0   X

The reading is in B11 (most significant bit) to B0.

The conversion time is 0.22 seconds.  If you try to read more
often the sensor will always return the last read value.
"""

pi = pigpio.pi()

if not pi.connected:
   exit(0)

# pi.spi_open(0, 1000000, 0)   # CE0, 1Mbps, main SPI
# pi.spi_open(1, 1000000, 0)   # CE1, 1Mbps, main SPI
# pi.spi_open(0, 1000000, 256) # CE0, 1Mbps, auxiliary SPI
# pi.spi_open(1, 1000000, 256) # CE1, 1Mbps, auxiliary SPI
# pi.spi_open(2, 1000000, 256) # CE2, 1Mbps, auxiliary SPI

sensor = pi.spi_open(2, 1000000, 256) # CE2 on auxiliary SPI

stop = time.time() + 600

while time.time() < stop:
   c, d = pi.spi_read(sensor, 2)
   if c == 2:
      word = (d[0]<<8) | d[1]
      if (word & 0x8006) == 0: # Bits 15, 2, and 1 should be zero.
         t = (word >> 3)/4.0
         print("{:.2f}".format(t))
      else:
         print("bad reading {:b}".format(word))
   time.sleep(0.25) # Don't try to read more often than 4 times a second.

pi.spi_close(sensor)

pi.stop()
