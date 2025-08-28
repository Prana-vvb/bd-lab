#!/bin/bash

# Set Java Environment Variable
export PATH=$JAVA_HOME/bin:$PATH
echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> ~/.bashrc

# Download Hive
wget https://archive.apache.org/dist/hive/hive-3.1.3/apache-hive-3.1.3-bin.tar.gz
tar -xvzf apache-hive-3.1.3-bin.tar.gz
sudo mv apache-hive-3.1.3-bin /opt/hive
rm apache-hive-3.1.3-bin.tar.gz

# Set Hive Environment Variables
export HIVE_HOME=/opt/hive
export PATH=$HIVE_HOME/bin:$PATH
echo "export HIVE_HOME=/opt/hive" >> ~/.bashrc
echo "export PATH=\$HIVE_HOME/bin:\$PATH" >> ~/.bashrc

# Configure Hive Directories
mkdir -p /opt/hive/hive_data/tmp
sudo chown -R $USER:$USER /opt/hive

# Configure hive-env.sh
cp $HIVE_HOME/conf/hive-env.sh.template $HIVE_HOME/conf/hive-env.sh
echo "export HADOOP_HOME=$HADOOP_HOME" >> $HIVE_HOME/conf/hive-env.sh
echo "export HIVE_CONF_DIR=$HIVE_HOME/conf" >> $HIVE_HOME/conf/hive-env.sh
echo "export HIVE_AUX_JARS_PATH=$HIVE_HOME/lib" >> $HIVE_HOME/conf/hive-env.sh

# Initialize Derby Metastore
"$HIVE_HOME/bin/schematool" -dbType derby -initSchema

echo "✅ Hive installation complete."
echo "ℹ️ Please run:  source ~/.bashrc"
echo "Then start Hive with: hive"
