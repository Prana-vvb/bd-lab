#!/bin/bash

mv ~/pig-0.17.0 ~/pig

echo "export PIG_HOME=~/pig" >> ~/.bashrc
echo "export PATH=\$PATH:\$PIG_HOME/bin" >> ~/.bashrc
echo "export PIG_CLASSPATH=\$HADOOP_HOME/etc/hadoop" >> ~/.bashrc
