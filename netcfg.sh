#!/usr/bin/env bash


default=192.168.1.1


while getopts "o:i:" opt; do
	case $opt in
		# specify the last octet for the local ip address
		o)
			newip=192.168.1.$OPTARG/24
			;;
		# specify the interface to setup ip address and route(optional)
		i)
			dev=$OPTARG
			;;
	esac
done


if [ -n "$dev" ]; then
	dev="$1"
else
	dev=$(ip route show default | awk '{print $5; exit}')
fi

if [ -z "$dev" ]; then
	dev=$(ip -o link show | awk -F': ' '$2 != "lo" {print $2; exit}')
fi

ip link set dev $dev down
echo "dev $dev down"

#adding a new local ip address
ip addr add $newip dev $dev
echo "adding new ip address at $newip"

ip link set dev $dev up
echo "dev $dev up"

#setup a default route for the packet to go
ip route add default via $default
echo "new default route added to $dev via $default"

echo "testing configure"
ping -c 4 8.8.8.8
if test -f /etc/resolv.conf ;then
	echo "file already exist"
	cat /etc/resolv.conf
else
	echo nameserver 8.8.8.8 > /etc/resolv.conf
fi
echo "testing respond from dns-server"
ping -c 4 google.com
