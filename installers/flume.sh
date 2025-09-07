#!/bin/bash

mv ~/apache-flume-1.11.0-bin ~/flume

echo "export FLUME_HOME=/home/\$USER/flume" >> ~/.bashrc
echo "export PATH=\$PATH:\$FLUME_HOME/bin" >> ~/.bashrc
