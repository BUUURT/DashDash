#!/usr/bin/python3
import RPi.GPIO as GPIO
from time import sleep
import time, math


rpm = 0
elapse = 0
sensor = 17
pulse = 0
start_timer = time.monotonic()

def init_GPIO():					# initialize GPIO
	GPIO.setmode(GPIO.BCM)
	GPIO.setwarnings(False)
	GPIO.setup(sensor,GPIO.IN,GPIO.PUD_UP)

def calculate_elapse(channel):				# callback function
	global pulse, start_timer, elapse
	pulse+=1								# increase pulse by 1 whenever interrupt occurred
	elapse = time.monotonic() - start_timer		# elapse for every 1 complete rotation made!
	start_timer = time.monotonic()				# let current time equals to start_timer

def calculate_speed():
	global pulse,elapse,rpm
	if elapse !=0:							# to avoid DivisionByZero error
		rpm = 1/elapse * 60
		return rpm

def init_interrupt():
	GPIO.add_event_detect(sensor, GPIO.FALLING, callback = calculate_elapse, bouncetime = 20)

if __name__ == '__main__':
	init_GPIO()
	init_interrupt()
	while True:
		calculate_speed()	# call this function with wheel radius as parameter
		print(f'rpm: {rpm}')
		sleep(0.01)
