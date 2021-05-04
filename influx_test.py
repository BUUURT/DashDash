from datetime import datetime
import time

from influxdb_client import InfluxDBClient, Point, WritePrecision
from influxdb_client.client.write_api import SYNCHRONOUS

# You can generate a Token from the "Tokens Tab" in the UI
token = "rc0LjEy36DIyrb1CX6rnUDeMJ0-ldW5Mps1KOwkSRrRhbRWDsGzPlNn6BOiyg96vWEKRMZ3xwsfZVgIAxL2gCw=="
org = "rammers"
bucket = "test4"

#client = InfluxDBClient(url="http://localhost:8086", token=token)
client = InfluxDBClient(url="192.168.254.40:8086", token=token)

write_api = client.write_api(write_options=SYNCHRONOUS)

data = "mem,host=host1 used_percent=23.43234543"
# write_api.write(bucket, org, data)

i = 0
# while True:
#     j = int(str(time.time()).split('.')[0][-1:])
#     i+=j
#     write_api.write(bucket, org, f"grower,bike=computer cycle3={i} {str(time.time()).replace('.','')+'0'}")
#     time.sleep(0.1)
#     print(i)
#
a={'speed': 0, 'rpm': 0, 'engTemp': 64.0, 'airTemp': 72.0, 'gps_lat': False, 'gps_long': False, 'rotationX': 360.0, 'rotationY': -3.625, 'rotationZ': 0.75, 'accelX': -0.62, 'accelY': -0.11, 'accelZ': 9.53, 'session': '15.751291086000492'}
# test = 'rammerRpi,lap=0 speed=10.63,rpm=0,engTemp=68.9,airTemp=68.9,gps_lat=None'#,gps_long=None,rotationX=0.0,rotationY=0.0,rotationZ=0.0,accelX=-0.76,accelY=-1.39,accelZ=9.42,laptime=0,s1Time=0,s2Time=0,s3Time=0 16195854652219036'
# write_api.write('test4', org, f'rammerRpi,lap=0 speed=0.27,rpm=0,engTemp=68.45,airTemp=68.45,gps_lat=False,gps_long=False,rotationX=0.0,rotationY=0.0,rotationZ=0.0,accelX=-0.81,accelY=-1.41,accelZ=9.43,laptime=0,s1Time=0,s2Time=0,s3Time=0 {str(time.time()).replace(".","")+"0"}')
write_api.write('test3', 'rammers', 'newData speed=1,airTemp=69.69')
print(a)
