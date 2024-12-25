#!/bin/bash

#declare -r COMMAND='provision'
declare -r COMMAND='install'
#declare -r COMMAND='uninstall'

declare -r TARGET='database'

declare -r ARCHIVE_DIR='/mnt/MySQL/Software/archive'
declare -r STAGING_DIR='/staging'
declare -r DATABASE_NAME='emrep'
declare -r DATABASE_PASSWORD='Abcd_1234'
#declare -r INSTALLATION_BASE='/u01/app'

./oem-installer.sh \
  --staging-directory="$STAGING_DIR" \
  --database-name="$DATABASE_NAME" \
  --database-password="$DATABASE_PASSWORD" \
  --database-package-file-name="${ARCHIVE_DIR}/V982063-01.zip" \
  --database-opatch-file-name="${ARCHIVE_DIR}/p6880880_190000_Linux-x86-64.zip" \
  --database-upgrade-patch-file-name="${ARCHIVE_DIR}/p36912597_190000_Linux-x86-64.zip" \
  "$COMMAND" "$TARGET"
