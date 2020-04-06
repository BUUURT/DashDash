# manage bike data over time
import os
import subprocess
import json


from flask import Flask, url_for, request
from markupsafe import escape


app = Flask(__name__)

@app.route('/')
def index():
    return 'index'

@app.route('/timeUpdate')
def timeUpdate():
    return request.args.get('sure',"")

@app.route('/dashDataUpdate')
def raceInit():

    payload = {
    "selfLaptime" : f"{request.args.get('selfLaptime')}",
    "selfLaps" : f"{request.args.get('selfLaps')}",
    "selfPosition" : f"{request.args.get('selfPosition')}",
    "opponentUpLaptime" : f"{request.args.get('opponentUpLaptime')}",
    "opponentUpLapDelta" : f"{request.args.get('opponentUpLapDelta')}",
    "opponentUpFaster" : f"{request.args.get('opponentUpFaster')}",
    "opponentUpGap" : f"{request.args.get('opponentUpGap')}",
    "opponentUpFaster" : f"{request.args.get('opponentUpFaster')}",
    "opponentUpGap" : f"{request.args.get('opponentUpGap')}",
    "opponentDownLaptime" : f"{request.args.get('opponentDownLaptime')}",
    "opponentDownLapdelta" : f"{request.args.get('opponentDownLapdelta')}",
    "opponentDownFaster" : f"{request.args.get('opponentDownFaster')}",
    "opponentDownGap" : f"{request.args.get('opponentDownGap')}"
    }

    # payload = str(payload).replace("'",'"')
    with open('dashData.json','w+') as file:
        json.dump(payload,file)

    # with open('dashData','w+') as file:
    #     file.write(payload)
    return ('success',200)

@app.route('/dashGet')
def dashGet():
    with open('dashData.json','r') as file:
        return file.read()



if __name__ == '__main__':
    app.run(debug=True,
            host=app.config.get("HOST", "192.168.254.12"),
            port=app.config.get("PORT", 9000)
            )
