#!/bin/bash

# $1: task_id
# $2 (optional): "username@host:" -- username and address to webserver host

SCRIPTS_PATH=/home/ema/gpu-monitor/scripts
WWW_DATA_PATH=/home/ema/www/data
TMP_DATA_PATH=/tmp/gpuReadings/${HOSTNAME}
mkdir -p ${TMP_DATA_PATH}

if [ "$1" -eq "1" ]; then
    nvidia-smi --format=csv,noheader,nounits --query-gpu=index,uuid,name,memory.used,memory.total,utilization.gpu,utilization.memory,temperature.gpu,timestamp -l 20 > ${TMP_DATA_PATH}/gpus.csv
fi

if [ "$1" -eq "2" ]; then
    nvidia-smi --format=csv,noheader,nounits --query-compute-apps=timestamp,gpu_uuid,used_gpu_memory,process_name,pid -l 20 > ${TMP_DATA_PATH}/processes.csv
fi

if [ "$1" -eq "3" ]; then
    while true; do
        df -l | grep " /local$" > ${TMP_DATA_PATH}/${HOSTNAME}_status.csv  # echo "" > ${TMP_DATA_PATH}/${HOSTNAME}_status.csv
        free -m | grep "Mem" >> ${TMP_DATA_PATH}/${HOSTNAME}_status.csv
        #top -b -n 1 | grep %Cpu >> ${TMP_DATA_PATH}/${HOSTNAME}_status.csv
        nproc --all >> ${TMP_DATA_PATH}/${HOSTNAME}_status.csv
        uptime >> ${TMP_DATA_PATH}/${HOSTNAME}_status.csv

        python ${SCRIPTS_PATH}/gpu-processes.py ${TMP_DATA_PATH}/processes.csv > ${TMP_DATA_PATH}/${HOSTNAME}_users.csv
        echo $(uptime | grep -o -P ': \K[0-9]*[,]?[0-9]*')\;$(nproc) > ${TMP_DATA_PATH}/${HOSTNAME}_cpus.csv
        tail -n 20 ${TMP_DATA_PATH}/gpus.csv > ${TMP_DATA_PATH}/${HOSTNAME}_gpus.csv
        tail -n 40 ${TMP_DATA_PATH}/processes.csv > ${TMP_DATA_PATH}/${HOSTNAME}_processes.csv
        scp ${TMP_DATA_PATH}/${HOSTNAME}_*.csv $2${WWW_DATA_PATH}
        sleep 10
    done
fi
