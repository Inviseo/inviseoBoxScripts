#!/bin/bash
sudo apt-get install wget -y
wget -qO- https://api.ipify.org | xargs echo
