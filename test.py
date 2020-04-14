# with open('test.json','w+') as file:
#     file.write('test')

# #
# import os
# # import subprocess
# #
# # subprocess.Popen(rf'python {os.getcwd()}\raceTimeCrawler.py')
#
# from subprocess import run, CREATE_NEW_CONSOLE
#
# run(rf'python {os.getcwd()}\raceTimeCrawler.py', creationflags=CREATE_NEW_CONSOLE)

import requests

i = requests.get(r'http://192.168.254.12:9000/dashGet')
