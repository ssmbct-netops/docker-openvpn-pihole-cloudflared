#!/bin/sh
#
# Script for updating spDYN dynamic DNS entries (https://spdyn.de)
# https://gist.github.com/harald-aigner/2282735f202cbb38f6893d4daec6f5fe
#
# Usage:
#   - Save this script as $HOME/bin/spDYN_update.sh
#   - Make it executable: chmod u+x $HOME/bin/spDYN_update.sh
#   - Create a cron entry (crontab -e) and supply <HOST_NAME> and <UPDATE_TOKEN>
#     according to your spDYN settings. Example for running every 10 minutes:
#       */10 * * * * $HOME/bin/spDYN_update.sh <HOST_NAME> <UPDATE_TOKEN> > /dev/null
#
# Logs are written to $HOME/.spDYN/
#
# spDYN_update.sh, Copyright 2017 Harald Aigner <harald.aigner@gmx.net>
# Licensed under the GPLv3 (https://www.gnu.org/licenses/gpl-3.0.txt)

if [ $# -ne 2 ]
then
  echo "Usage: $0 <HOST_NAME> <UPDATE_TOKEN>"
fi

HOST_NAME=$1
UPDATE_TOKEN=$2
DATE=`date "+%Y-%m-%d %H:%M:%S"`
UPDATE_URL="https://update.spdyn.de/nic/update"
CHECK_IP_URL="http://checkip4.spdyn.de"

ip_file="${HOME}/.spDYN/${HOST_NAME}"
log_dir="/var/log/spDYN/"
log_file="${log_dir}${HOST_NAME}.log"
old_ip="<not available>"

if [ -r ${ip_file} ]
then
  old_ip=$(cat ${ip_file})
else
  mkdir -p "${HOME}/.spDYN"
fi

if [ ! -r ${log_dir} ]
then
  mkdir -p "${log_dir}"
fi

ip=$(curl -s ${CHECK_IP_URL})
if [ -z "${ip}" ]
then
  echo "${DATE}: error retrieving IP" | tee -a "${log_file}"
  exit 1
fi
if [ "${ip}" = "${old_ip}" ]
then
  echo "${DATE}: no IP change (${ip})" | tee -a "${log_file}"
  exit 0
fi

echo "${DATE}: detected new IP: ${old_ip} -> ${ip}" | tee -a "${log_file}"
echo "${ip}" > "${ip_file}"
echo "${DATE}: wrote new IP to ${ip_file}" | tee -a "${log_file}"
response=$(curl -su "${HOST_NAME}:${UPDATE_TOKEN}" "${UPDATE_URL}?hostname=${HOST_NAME}&myip=${ip}")
echo "${DATE}: response: ${response}" | tee -a "${log_file}"


