import RPi.GPIO as GPIO
from time import sleep
import time, math

class GPIO_hall:
    def __init__(self, sensor):
        self.distance = 0.0
        self.mph = 0
        self.rpm = 0
        self.elapse = 0
        self.pulse = 0
        self.start_timer = time.time()
        self.sensor = sensor
        self.wheelRadius_cm = 43
        self.distance_measured = 0

        GPIO.setmode(GPIO.BCM)
        GPIO.setwarnings(False)
        GPIO.setup(sensor, GPIO.IN, GPIO.PUD_UP)

        def calculate_elapse(self.channel):
            self.pulse += 1
            self.elapse = time.time() - start_timer
            self.start_timer = time.time()

        GPIO.add_event_detect(self.sensor, GPIO.FALLING, callback = calculate_elapse, bouncetime = 20)

    def speed():
    	if self.elapse !=0:

            ,rpm,dist_km,dist_meas,km_per_sec,km_per_hour
            				# to avoid DivisionByZero error
    		self.rpm = 1/elapse * 60
    		circ_cm = (2*math.pi)*self.wheelRadius_cm			# calculate wheel circumference in CM
    		dist_km = circ_cm/100000 			# convert cm to km
            km_per_sec = dist_km / self.elapse		# calculate KM/sec
    		km_per_hour = km_per_sec * 3600		# calculate KM/h
    		dist_meas = (dist_km*pulse)*1000	# measure distance traverse in meter
    		return km_per_hour
