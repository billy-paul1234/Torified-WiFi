#!/bin/bash

# check ap0 created or not
if [ "$(iwconfig | grep ap0 | awk '{print $1}')" != "ap0" ]; then
    echo "
     ifconfig wlan0 down
     iw dev wlan0 interface add ap0 type __ap
"
    ifconfig wlan0 down
    iw dev wlan0 interface add ap0 type __ap
fi

# check ap0 mode
if [ "$(iwconfig ap0 | grep ap0 | awk '{print $4}')" != "Mode:Master" ]; then
    echo "
     ifconfig ap0 down
     iw dev ap0 set type __ap
"
    ifconfig ap0 down
    iw dev ap0 set type __ap
    ip addr add 192.168.40.1/24 dev ap0

fi

# check ap0 ip
if [ "$(ifconfig ap0 | grep inet | awk '{print $2}')" != "192.168.40.1" ]; then
    echo "
     ifconfig ap0 down
     iw dev ap0 set type __ap
     ip addr add 192.168.40.1/24 dev ap0
"
    ifconfig ap0 down
    iw dev ap0 set type __ap
    ip addr add 192.168.40.1/24 dev ap0
fi

# start all services
echo "
service tor restart
service dnsmasq restart
"
service tor restart
service dnsmasq restart

if [ "$(service hostapd status | grep hostapd | grep error)" != "" ] || [ "$(sudo service hostapd status | grep hostapd | grep fail)" != "" ] || [ "$(sudo service hostapd status | grep hostapd | grep -v load | grep disable)" != "" ] || [ "$(service hostapd status | grep -i active | awk '{print $2}')" != "active" ]; then
    echo "service hostapd restart"
    service hostapd restart
fi
