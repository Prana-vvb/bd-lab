#!/bin/bash

sudo apt update -y

sudo service ssh start
start-all.sh

exec "$@"
