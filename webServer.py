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

    payload = str({
    "selfLaptime" : str(request.args.get("selfLaptime")),
    "selfLaps" : str(request.args.get("selfLaps")),
    "selfPosition" : str(request.args.get("selfPosition")),
    "opponentUpLaptime" : str(request.args.get("opponentUpLaptime")),
    "opponentUpLapDelta" : str(request.args.get("opponentUpLapDelta")),
    "opponentUpFaster" : str(request.args.get("opponentUpFaster")),
    "opponentUpGap" : str(request.args.get("opponentUpGap")),
    "opponentUpFaster" : str(request.args.get("opponentUpFaster")),
    "opponentUpGap" : str(request.args.get("opponentUpGap")),
    "opponentDownLaptime" : str(request.args.get("opponentDownLaptime")),
    "opponentDownLapdelta" : str(request.args.get("opponentDownLapdelta")),
    "opponentDownFaster" : str(request.args.get("opponentDownFaster")),
    "opponentDownGap" : str(request.args.get("opponentDownGap"))
    })


### todo - get off json
    with open('dashData.json','w+') as file:

        file.write(json.loads(payload))

@app.route('/test')
def test():
    return 'test'


if __name__ == '__main__':
    app.run(debug=True,
            host=app.config.get("HOST", "192.168.254.12"),
            port=app.config.get("PORT", 9000)
            )
