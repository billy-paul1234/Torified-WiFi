#!/bin/bash

# disable ipv6 and enable packet forward
if [ "$(cat /etc/sysctl.conf | grep -o ap0)" = "ap0" ]; then
    {
        echo "net.ipv6.conf.all.disable_ipv6 = 1 #ap0"
        echo "net.ipv6.conf.default.disable_ipv6=1 #ap0"
        echo "net.ipv4.ip_forward=1 #ap0"
    } >>/etc/sysctl.conf
    sysctl -p >/dev/null # have sysctl reread /etc/sysctl.conf
fi

# check ap0 created or not
if [ "$(iwconfig | grep ap0 | awk '{print $1}')" != "ap0" ]; then
    echo "
    sudo ifconfig wlan0 down
    sudo iw dev wlan0 interface add ap0 type __ap
"
    sudo ifconfig wlan0 down
    sudo iw dev wlan0 interface add ap0 type __ap
fi

# check ap0 mode
# if [ "$(iwconfig ap0 | grep ap0 | awk '{print $4}')" != "Mode:Master" ]; then
echo "
    sudo ifconfig ap0 down
    sudo iw dev ap0 set type __ap
"
sudo ifconfig ap0 down
sudo iw dev ap0 set type __ap
sudo ip addr add 192.168.40.1/24 dev ap0

# fi

# check ap0 ip
# if [ "$(ifconfig ap0 | grep inet | awk '{print $2}')" != "192.168.40.1" ]; then
echo "
    sudo ip addr add 192.168.40.1/24 dev ap0
"
sudo ifconfig ap0 down
sudo iw dev ap0 set type __ap
sudo ip addr add 192.168.40.1/24 dev ap0
# fi

# configure firewall
# clear old firewall rules
sudo iptables -F && sudo iptables -t nat -F && sudo ebtables -F && sudo ip6tables -F && sudo arptables -F

# allow internet access for ap0
sudo iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE

# to connect the system to tor
sudo iptables -t nat -A OUTPUT -p tcp --dport 80 -j REDIRECT --to-ports 9040
sudo iptables -t nat -A OUTPUT -p tcp --dport 443 -j REDIRECT --to-ports 9040
sudo iptables -t nat -A OUTPUT -p icmp -j REDIRECT --to-ports 9040
sudo iptables -t nat -A OUTPUT -p udp --dport 80 -j REDIRECT --to-ports 9040
sudo iptables -t nat -A OUTPUT -p udp --dport 443 -j REDIRECT --to-ports 9040

# to connect the ap network to tor
sudo iptables -t nat -A PREROUTING -i ap0 -p tcp --dport 80 -j REDIRECT --to-ports 9040
sudo iptables -t nat -A PREROUTING -i ap0 -p tcp --dport 443 -j REDIRECT --to-ports 9040
sudo iptables -t nat -A PREROUTING -i ap0 -p icmp -j REDIRECT --to-ports 9040
sudo iptables -t nat -A PREROUTING -i ap0 -p udp --dport 80 -j REDIRECT --to-ports 9040
sudo iptables -t nat -A PREROUTING -i ap0 -p udp --dport 443 -j REDIRECT --to-ports 9040

# start all services
sudo service tor restart
sudo service dnsmasq restart
sudo service hostapd restart

if [ "$(service hostapd status | grep hostapd | grep error)" != "" ] || [ "$(sudo service hostapd status | grep hostapd | grep fail)" != "" ] || [ "$(sudo service hostapd status | grep hostapd | grep disable)" != "" ] || [ "$(service hostapd status | grep -i active | awk '{print $2}')" != "active" ]; then
    sudo service hostapd restart
fi
