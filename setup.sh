#!/bin/bash

HADOOP=./installers/hadoop-3.3.6.tar.gz
HIVE=./installers/apache-hive-3.1.3-bin.tar.gz
FLUME=./installers/apache-flume-1.11.0-bin.tar.gz

read -p "Enter SRN in lowercase: " srn

if [ ! -f "$HADOOP" ]; then
    wget -P ./installers https://dlcdn.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz
else
    echo "Hadoop found. Skipping download."
fi

if [ ! -f "$HIVE" ]; then
    wget -P ./installers https://archive.apache.org/dist/hive/hive-3.1.3/apache-hive-3.1.3-bin.tar.gz
else
    echo "Hive found. Skipping download."
fi

if [ ! -f "$FLUME" ]; then
    wget -P ./installers https://downloads.apache.org/flume/1.11.0/apache-flume-1.11.0-bin.tar.gz
else
    echo "Flume found. Skipping download."
fi

docker build --no-cache --build-arg username="$srn" -t bdlab .
