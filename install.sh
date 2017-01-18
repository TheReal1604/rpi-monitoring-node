#!/bin/bash
# This is an install script for your rpi, its not tested yet!

rpiversion=$(uname -m)

echo ## Install https transport for apt.. ###
sudo apt-get update
sudo apt-get install apt-transport-https curl -y

echo ## Adding package repos.. ##
curl https://bintray.com/user/downloadSubjectPublicKey?username=bintray | sudo apt-key add -
# Try to find if the system is a rpi1

if [ "$rpiversion" == armv6l ]
then 
  echo ## Raspberry Pi 1 detected.. ##
  echo "deb https://dl.bintray.com/fg2it/deb-rpi-1b jessie main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
else
  echo ## Raspberry Pi 2 or 3 detected.. ##
  echo "deb https://dl.bintray.com/fg2it/deb jessie main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
fi

curl -sL https://repos.influxdata.com/influxdb.key | apt-key add -source /etc/os-release
echo "deb https://repos.influxdata.com/debian jessie stable" | tee -a /etc/apt/sources.list

echo ### Updating package repository ###
sudo apt-get update
echo ### Installing influxdb, telegraf and grafana.. ###
sudo apt-get install influxdb telegraf grafana -y

echo ## Installation finished.. configuring.. ##
