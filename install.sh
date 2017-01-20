#!/bin/bash
# This is an install script for your rpi, its not tested yet!

rpiversion=$(uname -m)
ipadress=$(ip addr show | grep -E '^\s*inet' | grep -m1 global | awk '{ print $2 }' | sed 's|/.*||')

echo "## Install https transport for apt.. ##"
apt-get update
apt-get install apt-transport-https curl pwgen -y

echo "## Adding package repos.. ##"
curl https://bintray.com/user/downloadSubjectPublicKey?username=bintray | apt-key add -
# Try to find if the system is a rpi1

if [ "$rpiversion" == armv6l ]
then 
  echo ## Raspberry Pi 1 detected.. ##
  echo "deb https://dl.bintray.com/fg2it/deb-rpi-1b jessie main" | tee -a /etc/apt/sources.list.d/grafana.list
else
  echo ## Raspberry Pi 2 or 3 detected.. ##
  echo "deb https://dl.bintray.com/fg2it/deb jessie main" | tee -a /etc/apt/sources.list.d/grafana.list
fi

curl -sL https://repos.influxdata.com/influxdb.key | apt-key add - 
echo "deb https://repos.influxdata.com/debian jessie stable" | tee -a /etc/apt/sources.list

echo "### Updating package repository ###"
apt-get update

echo "### Installing influxdb, telegraf and grafana.. ###"
apt-get install influxdb telegraf grafana -y

echo "## Installation finished.. configuring.. ##"
cp configs/telegraf.conf /etc/telegraf/telegraf.conf
cp configs/grafana.ini /etc/grafana/grafana.ini
cp scripts/getexternalip.sh /tmp/getexternalip.sh

echo "## Adding autostart for all services..##"
systemctl daemon-reload
systemctl enable grafana-server
systemctl enable telegraf
systemctl enable influxdb

echo "## Starting all services the first time ##"
systemctl start influxdb
systemctl start grafana-server
systemctl start telegraf

echo "## Enabling Grafana Plugins ##"
grafana-cli plugins install grafana-clock-panel
grafana-cli plugins install grafana-piechart-panel
systemctl restart grafana-server

#echo "## Resetting Passwords..##"
#pw=$(pwgen -y 8 1)
#grafana-cli admin reset-admin-password $pw

echo "## Enabling InfluxDB datasource in Grafana.. ##"
curl 'http://admin:$pw@127.0.0.1:3000/api/datasources' -X POST -H 'Content-Type: application/json;charset=UTF-8' --data-binary '{"name":"influx","type":"influxdb","url":"http://localhost:8086","access":"proxy","isDefault":true,"database":"telegraf","user":"","password":""}'
echo "## Adding your monitoring Dashboard ##"
curl -XPOST -i http://admin:$pw@localhost:3000/api/dashboards/db --data-binary @./dashboards/dashboard.json -H "Content-Type: application/json"

echo "###############################"
echo "## Grafana Username: admin   ##"
echo "## Password: admin           ##"
echo "## URL: http://$ipadress:3000##"
echo "###############################"
