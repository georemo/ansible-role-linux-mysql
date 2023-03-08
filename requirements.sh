#!/bin/bash

apt-get update
apt-get install python3 python3-pip uuidgen openssl -y
sudo apt install python3-pip -y
pip3 install pipenv
pipenv shell
pip install -r requirements.txt