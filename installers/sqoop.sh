#!/bin/bash
set -e

SQOOP_VERSION="1.4.7"
SQOOP_HOME="$HOME/sqoop-${SQOOP_VERSION}"

mv "sqoop-${SQOOP_VERSION}.bin__hadoop-2.6.0" "$SQOOP_HOME"

if ! grep -q "SQOOP_HOME" ~/.bashrc; then
  {
    echo "export SQOOP_HOME=$SQOOP_HOME"
    echo 'export PATH=$PATH:$SQOOP_HOME/bin'
    echo "export HADOOP_COMMON_HOME=$HADOOP_HOME"
    echo "export HADOOP_MAPRED_HOME=$HADOOP_HOME"
  } >> ~/.bashrc
fi

cd "$SQOOP_HOME/conf"
cp sqoop-env-template.sh sqoop-env.sh
echo "export HADOOP_COMMON_HOME=$HADOOP_HOME" >> sqoop-env.sh
echo "export HADOOP_MAPRED_HOME=$HADOOP_HOME" >> sqoop-env.sh

cd "$HOME"
JDBC_DIR=$(find . -maxdepth 1 -type d -name "mysql-connector-*")
mv $JDBC_DIR/mysql-connector-*.jar "$SQOOP_HOME/lib/"
