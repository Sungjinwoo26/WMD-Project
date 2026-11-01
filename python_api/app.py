from datetime import datetime, timedelta, timezone

import jwt
from flask import Flask, jsonify, request
from werkzeug.security import check_password_hash, generate_password_hash

app = Flask(__name__)
app.config['SECRET_KEY'] = 'college-project-secret-key'

# User store for the authentication service.
users = {}


@app.post('/register')
def register():
    data = request.get_json() or {}
    username = data.get('username', '').strip()
    password = data.get('password', '')

    if not username or not password:
        return jsonify({'message': 'Username and password are required'}), 400
    if username in users:
        return jsonify({'message': 'User already exists'}), 400

    users[username] = generate_password_hash(password)
    return jsonify({'message': 'User registered successfully'}), 201


@app.post('/login')
def login():
    data = request.get_json() or {}
    username = data.get('username', '').strip()
    password = data.get('password', '')

    if username not in users or not check_password_hash(users[username], password):
        return jsonify({'message': 'Invalid username or password'}), 401

    payload = {
        'username': username,
        'exp': datetime.now(timezone.utc) + timedelta(hours=1),
    }
    token = jwt.encode(payload, app.config['SECRET_KEY'], algorithm='HS256')
    return jsonify({'token': token})


@app.get('/dashboard')
def dashboard():
    header = request.headers.get('Authorization', '')
    if not header.startswith('Bearer '):
        return jsonify({'message': 'Bearer token is required'}), 401

    token = header.split(' ', 1)[1]
    try:
        user = jwt.decode(token, app.config['SECRET_KEY'], algorithms=['HS256'])
        return jsonify({'message': f"Welcome {user['username']}", 'access': 'granted'})
    except jwt.ExpiredSignatureError:
        return jsonify({'message': 'Token has expired'}), 401
    except jwt.InvalidTokenError:
        return jsonify({'message': 'Invalid token'}), 401


if __name__ == '__main__':
    app.run(debug=True, port=5000)
