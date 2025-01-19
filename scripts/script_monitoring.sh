#!/bin/bash


LOG_DIR="$(dirname "$0")/../logs"
STATUS_FILE="$(dirname "$0")/../web/status.json"
NGINX_SERVICE="nginx"

mkdir -p "$LOG_DIR"


if systemctl is-active --quiet $NGINX_SERVICE; then
    DATE=$(date "+%Y-%m-%d %H:%M:%S")  
    echo "$DATE - $NGINX_SERVICE - ONLINE" >> "$LOG_DIR/status_online.log"
    echo '{"status": "online", "timestamp": "'"$DATE"'"}' > "$STATUS_FILE"
else
    DATE=$(date "+%Y-%m-%d %H:%M:%S")  
    echo "$DATE - $NGINX_SERVICE - OFFLINE" >> "$LOG_DIR/status_offline.log"
    echo '{"status": "offline", "timestamp": "'"$DATE"'"}' > "$STATUS_FILE"
fi
