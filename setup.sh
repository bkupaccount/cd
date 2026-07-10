#!/bin/bash

set -e

TIMEZONE="Asia/Jakarta"
CRON_SCHEDULE="0 3 * * 0"
COMMAND="/sbin/reboot"
CRON_JOB="${CRON_SCHEDULE} ${COMMAND}"

if [ "$(id -u)" -ne 0 ]; then
    echo "[ERROR] This script requires root privileges. Please run with sudo." >&2
    exit 1
fi

echo "[INFO] Starting auto-reboot configuration..."

echo "[INFO] Setting system timezone to ${TIMEZONE}..."
if ! timedatectl set-timezone "${TIMEZONE}"; then
    echo "[ERROR] Failed to set timezone." >&2
    exit 1
fi

echo "[INFO] Checking current crontab configuration..."

if crontab -l 2>/dev/null | grep -Fq "${CRON_JOB}"; then
    echo "[INFO] Auto-reboot schedule is already configured. No changes made."
else
    echo "[INFO] Adding new schedule to crontab..."
    if (crontab -l 2>/dev/null; echo "${CRON_JOB}") | crontab -; then
        echo "[INFO] Schedule successfully added (Sunday, 03:00 local time)."
    else
        echo "[ERROR] Failed to update crontab." >&2
        exit 1
    fi
fi

echo "[INFO] Configuration complete."
echo "[INFO] Current server time: $(date)"

exit 0
