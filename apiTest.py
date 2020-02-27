import os
import subprocess

from flask import Flask, render_template
from flask_restplus import Api, Resource
from werkzeug.utils import cached_property

flask_app = Flask(__name__)
app = Api(app = flask_app)

name_space = app.namespace('main', description = 'Main APIs')


@name_space.route('/')
class MainClass(Resource):
    def home():
        return render_template("home.html")
    # def get(self):
    #     return {
    #             "status":"Got new data"
    #     }
    # def post(self):
    #     return {
    #             "status":"Posted new data"
    #     }

if __name__ == "__main__":
    flask_app.run(
    host=flask_app.config.get("HOST", "192.168.254.12"),
    port=flask_app.config.get("PORT", 9000)
    )
