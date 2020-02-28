#!/bin/bash
# Aurthor: Muhammad Asim
# CoAuthor mr-bolle

OVPN_DATA=$PWD/openvpn_data
export OVPN_DATA

#Step 5
echo -e "\nList of clients:\n"
docker run -v $OVPN_DATA:/etc/openvpn --rm -it kylemanna/openvpn ovpn_listclients

sleep 1
read -p "Please Provide Your Client Name " CLIENTNAME

docker run -v $OVPN_DATA:/etc/openvpn --rm -it kylemanna/openvpn ovpn_revokeclient $CLIENTNAME remove
