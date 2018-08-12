#!/bin/bash

WWW_PATH=www
IP=0.0.0.0
PORT=8000
SCREEN_NAME=gpu-monitor


screen -dmS ${SCREEN_NAME}
screen -S ${SCREEN_NAME} -X stuff "cd ${WWW_PATH}\nphp -S ${IP}:${PORT}\n"
