#!/bin/bash

hadoop=./installers/hadoop-3.3.6.tar.gz
hive=./installers/apache-hive-3.1.3-bin.tar.gz
flume=./installers/apache-flume-1.11.0-bin.tar.gz
pig=./installers/pig-0.17.0.tar.gz
commons_lang=./installers/commons-lang-2.6.jar

read -p "Enter SRN in lowercase: " srn
srn=$(echo "$srn" | tr '[:upper:]' '[:lower:]')

if [ ! -f "$hadoop" ]; then
    wget -P ./installers https://dlcdn.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz
else
    echo "Hadoop found. Skipping download."
fi

if [ ! -f "$hive" ]; then
    wget -P ./installers https://archive.apache.org/dist/hive/hive-3.1.3/apache-hive-3.1.3-bin.tar.gz
else
    echo "Hive found. Skipping download."
fi

if [ ! -f "$flume" ]; then
    wget -P ./installers https://downloads.apache.org/flume/1.11.0/apache-flume-1.11.0-bin.tar.gz
else
    echo "Flume found. Skipping download."
fi

if [ ! -f "$pig" ]; then
    wget -P ./installers https://dlcdn.apache.org/pig/pig-0.17.0/pig-0.17.0.tar.gz
else
    echo "Pig found. Skipping download."
fi

if [ ! -f "$commons_lang" ]; then
    wget -P ./installers https://repo1.maven.org/maven2/commons-lang/commons-lang/2.6/commons-lang-2.6.jar
else
    echo "Commons-lang found. Skipping download."
fi

docker build --no-cache --build-arg username="$srn" -t bdlab .
