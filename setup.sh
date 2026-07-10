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

echo "============================================================"
echo "[WARNING] THIS SCRIPT WILL DELETE ALL EXISTING ROOT CRON JOBS."
echo "[WARNING] Press Ctrl+C within 5 seconds to cancel..."
echo "============================================================"
sleep 5

echo "[INFO] Starting auto-reboot configuration..."

echo "[INFO] Setting system timezone to ${TIMEZONE}..."
if ! timedatectl set-timezone "${TIMEZONE}"; then
    echo "[ERROR] Failed to set timezone." >&2
    exit 1
fi

echo "[INFO] Wiping all existing root cron jobs..."
crontab -r 2>/dev/null || true
echo "[INFO] Old crontab cleared."

echo "[INFO] Adding new schedule to a fresh crontab..."
if echo "${CRON_JOB}" | crontab -; then
    echo "[INFO] Schedule successfully added (Sunday, 03:00 local time)."
else
    echo "[ERROR] Failed to update crontab." >&2
    exit 1
fi

echo "[INFO] Configuration complete."
echo "[INFO] Current server time: $(date)"

exit 0
