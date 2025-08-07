#!/bin/bash

# Define the source and destination directories
LOG_SRC_DIR="/var/log"
LOG_DEST_DIR="/host_logs"

# Ensure destination directories exist
mkdir -p "${LOG_DEST_DIR}/supervisord"
mkdir -p "${LOG_DEST_DIR}/letsencrypt"

# Copy the specified log files
cp "${LOG_SRC_DIR}/cron.log" "${LOG_DEST_DIR}/cron.log"
cp "${LOG_SRC_DIR}/supervisord/supervisord.log" "${LOG_DEST_DIR}/supervisord/supervisord.log"
cp "${LOG_SRC_DIR}/letsencrypt/letsencrypt.log" "${LOG_DEST_DIR}/letsencrypt/letsencrypt.log"

# Set broad permissions for the host to be able to read/write
chmod -R 777 "${LOG_DEST_DIR}"
