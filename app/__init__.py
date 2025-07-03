from flask import Flask
from flask_mysqldb import MySQL
import config  # your DB config

app = Flask(__name__)
app.secret_key = 'your_secret_key_here'  # Change this to a strong secret

# MySQL configuration
app.config['MYSQL_HOST'] = config.DB_HOST
app.config['MYSQL_USER'] = config.DB_USER
app.config['MYSQL_PASSWORD'] = config.DB_PASSWORD
app.config['MYSQL_DB'] = config.DB_NAME

mysql = MySQL(app)

# Import routes here
from app import routes
