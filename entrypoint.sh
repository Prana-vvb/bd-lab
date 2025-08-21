#!/bin/bash

sudo apt update -y && sudo apt upgrade -y
sudo service ssh start
exec "$@"
