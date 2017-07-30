#!/bin/bash

API_KEY=""
API_USERNAME=""
BACKUPS_ENDPOINT="" # e.g. https<://<YOUR_DISCOURSE_HOST>/admin/backups.json
LOG_FILE="/var/log/discourse.backup.cron.log"

curl "$BACKUPS_ENDPOINT?api_key=$API_KEY&api_username=$API_USERNAME" \
  -X POST \
  --data "with_uploads=true" \
  -v \
  >> "$LOG_FILE"
