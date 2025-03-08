#!/bin/bash

# clear firewall rules
echo "
clearing firewall rules.....
"
iptables -F && sudo iptables -t nat -F && sudo ebtables -F && sudo ip6tables -F && sudo arptables -F

# delete ap
if [ "$(ifconfig | grep ap0 | awk '{print $1}')" = "ap0:" ]; then
    echo "deleting ap0 Wireless Access Point...."
    iw dev ap0 del
fi

# make the wlan0 up and Reseting NetworkManager
echo "Make the wlan0 up and Reseting NetworkManager...."
ifconfig wlan0 up
service NetworkManager restart

# Stop all services
echo "Stoping tor, dnsmasq and hostapd....."
service tor stop
service dnsmasq stop
service hostapd stop
