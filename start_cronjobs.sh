#!/bin/bash

SCRIPT_PATH=/home/ema/gpu-monitor/scripts
WWW_HOST=  # optional "username@host:" -- username and address to webserver host


(crontab -l 2>/dev/null;\
echo -e "# Check if monitoring is running every 5 mins\n\
*/5 * * * * ${SCRIPT_PATH}/gpu-check.sh ${HOSTNAME} ${WWW_HOST} > /dev/null 2>&1\n\
# Kill and restart the monitoring every 2 hours and cleanup the output files of the monitors\n\
0 */2 * * * ${SCRIPT_PATH}/gpu-check.sh kill > /dev/null 2>&1; ${SCRIPT_PATH}/gpu-check.sh ${HOSTNAME} ${WWW_HOST} > /dev/null 2&>1\
") | crontab -
