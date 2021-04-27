from datetime import datetime
import time

from influxdb_client import InfluxDBClient, Point, WritePrecision
from influxdb_client.client.write_api import SYNCHRONOUS

# You can generate a Token from the "Tokens Tab" in the UI
token = "JsGcGk3NLpEAN4NEQy7piJCL4fGVSBOSsPBKHWkLkP8DKlz6slQh9TFoC5VBwuHkMoDWFvrnOP1t90TTPdRfuA=="
org = "rammers"
bucket = "test3"

#client = InfluxDBClient(url="http://localhost:8086", token=token)
client = InfluxDBClient(url="192.168.254.40:8086", token=token)

write_api = client.write_api(write_options=SYNCHRONOUS)

data = "mem,host=host1 used_percent=23.43234543"
# write_api.write(bucket, org, data)

i = 0
while True:
    j = int(str(time.time()).split('.')[0][-1:])
    i+=j
    write_api.write(bucket, org, f"grower,bike=computer cycle3={i} {str(time.time()).replace('.','')+'0'}")
    time.sleep(0.1)
    print(i)
