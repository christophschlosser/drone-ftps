#!/bin/bash

if [ -z "$FTP_USERNAME" ]; then
    echo "Need to set username"
    exit 1
fi

if [ -z "$PLUGIN_HOSTNAME" ]; then
    echo "Need to set hostname"
    exit 1
fi

if [ -z "$PLUGIN_SECURE" ]; then
    PLUGIN_SECURE="true"
fi

if [ -z "$PLUGIN_VERIFY" ]; then
    PLUGIN_VERIFY="true"
fi

if [ -z "$PLUGIN_DEST_DIR" ]; then
    PLUGIN_DEST_DIR="/"
fi

if [ -z "$PLUGIN_SRC_DIR" ]; then
    PLUGIN_SRC_DIR="/"
fi

PLUGIN_EXCLUDE_STR=""
PLUGIN_INCLUDE_STR=""

IFS=',' read -ra in_arr <<< "$PLUGIN_EXCLUDE"
for i in "${in_arr[@]}"; do
    PLUGIN_EXCLUDE_STR="$PLUGIN_EXCLUDE_STR -x $i"
done
IFS=',' read -ra in_arr <<< "$PLUGIN_INCLUDE"
for i in "${in_arr[@]}"; do
    PLUGIN_INCLUDE_STR="$PLUGIN_INCLUDE_STR -x $i"
done

lftp -e "set xfer:log 1; \
  set ftp:ssl-allow $PLUGIN_SECURE; \
  set ftp:ssl-force $PLUGIN_SECURE; \
  set ssl:verify-certificate $PLUGIN_VERIFY; \
  set ssl:check-hostname $PLUGIN_VERIFY; \
  mirror --verbose -R $PLUGIN_INCLUDE_STR $PLUGIN_EXCLUDE_STR $(pwd)$PLUGIN_SRC_DIR $PLUGIN_DEST_DIR" \
  -u $FTP_USERNAME,$FTP_PASSWORD $PLUGIN_HOSTNAME
