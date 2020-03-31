# manage bike data over time
import os
import subprocess


from flask import Flask, url_for, request
from markupsafe import escape


app = Flask(__name__)

@app.route('/')
def index():
    return 'index'

@app.route('/timeUpdate')
def timeUpdate():
    return request.args.get('sure',"")

@app.route('/raceInit')
def raceInit():
    raceId = request.args.get('raceId')
    teamId = request.args.get('teamId')
    subprocess.Popen(f'python raceTimeCrawler.py')#

@app.route('/test')
def test():
    return 'test'


if __name__ == '__main__':
    app.run(debug=True,
            host=app.config.get("HOST", "192.168.254.12"),
            port=app.config.get("PORT", 9000)
            )
