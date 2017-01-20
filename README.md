# rpi-monitoring-node

A repo to automate the installation of telegraf, influxdb and grafana on your raspberry pi with a predefined dashboard.

Its based on:

https://github.com/influxdata/influxdb

https://github.com/influxdata/telegraf

<img src="https://upload.wikimedia.org/wikipedia/en/f/f5/InfluxDB_logo.svg" height="200">

https://github.com/grafana/grafana

<img src="https://camo.githubusercontent.com/7f7d8e67efe1cfb2a63b8024ed1e8fe66fa9b70b/68747470733a2f2f662e636c6f75642e6769746875622e636f6d2f6173736574732f31303939392f323531383832302f64626231313031612d623436382d313165332d393162662d3234326339633633326330372e504e47" height="200">


Work in progress.

# Install Steps

* install clean raspbian jessie on your pi
* `apt-get install git`
* `git clone https://github.com/TheReal1604/rpi-monitoring-node.git`
* `cd rpi-monitoring-node`
* `chmod +x install.sh`
* `sudo ./install.sh`
* Just wait some minutes until your fresh configured grafana instance is spawning
* open browser and access the url shown in the terminal:

If you want to add some telegraf plugins, edit the telegraf conf:

`vi /etc/telegraf/telegraf.conf`

# ToDos
* Implement that the password from grafana admin is changed (grafana-cli is not working atm..)
* Implement better dashboard
* Implement external IP check

# Screenshots
<img src=https://cdn.cloudreboot.de/github/rpi-monitoring-node.png>
