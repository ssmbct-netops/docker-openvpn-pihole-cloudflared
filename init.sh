#!/bin/bash

echo "Get source repositories"
apt-get update && apt-get install -y git

git clone https://github.com/mr-bolle/docker-openvpn-pihole.git

cp docker-openvpn-pihole/openvpn-client.sh .
cp docker-openvpn-pihole/openvpn-install.sh .

chmod +x openvpn-client.sh
chmod +x openvpn-install.sh
./openvpn-install.sh

rm -rf docker-openvpn-pihole openvpn-install.sh