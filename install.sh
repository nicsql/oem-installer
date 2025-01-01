#!/bin/bash

#declare -r COMMAND='prepare'
#declare -r COMMAND='provision'
declare -r COMMAND='install'
#declare -r COMMAND='uninstall'

#declare -r TARGET='database'
declare -r TARGET='em'

declare -r ARCHIVE_DIR='/mnt/MySQL/Software/archive'
declare -r STAGING_DIR='/staging'
declare -r DATABASE_NAME='emrep'
declare -r DATABASE_HOSTNAME='oem13cc-ol9-2.public.nicolas.oraclevcn.com'
declare -r -i DATABASE_PORT=1521
declare -r DATABASE_PASSWORD='Abcd_1234'
declare -r DATABASE_BASE_DATA_DIRECTORY='/u01/oradata/database'

if [[ 'database' == "$TARGET" ]] ; then
  ./oem-installer.sh \
    --staging-directory="$STAGING_DIR" \
    --database-name="$DATABASE_NAME" \
    --database-password="$DATABASE_PASSWORD" \
    --database-package-file-name="${ARCHIVE_DIR}/V982063-01.zip" \
    --database-opatch-file-name="${ARCHIVE_DIR}/p6880880_190000_Linux-x86-64.zip" \
    --database-upgrade-patch-file-name="${ARCHIVE_DIR}/p36912597_190000_Linux-x86-64.zip" \
    "$COMMAND" "$TARGET"
else
  declare -r INSTALLATION_BASE='/opt/oracle'
  declare -r INVENTORY_DIRECTORY="${INSTALLATION_BASE}/oraInventory"
  declare -r APPLICATIONS_BASE_DIRECTORY="${INSTALLATION_BASE}/product"
  declare -r MANAGER_BASE_DIRECTORY="${APPLICATIONS_BASE_DIRECTORY}/oem"
  declare -r MANAGER_HOME_DIRECTORY="${MANAGER_BASE_DIRECTORY}/13.5.0.0.0"
  declare -r MANAGER_INSTANCE_DIRECTORY="${MANAGER_BASE_DIRECTORY}/gc_inst"
  declare -r AGENT_BASE_DIRECTORY="${APPLICATIONS_BASE_DIRECTORY}/oemagent"
  ./oem-installer.sh \
    --staging-directory="$STAGING_DIR" \
    --inventory-directory="$INVENTORY_DIRECTORY" \
    --base-applications-directory="$APPLICATIONS_BASE_DIRECTORY" \
    --database-name="$DATABASE_NAME" \
    --database-hostname="$DATABASE_HOSTNAME" \
    --database-port=$DATABASE_PORT \
    --database-password="$DATABASE_PASSWORD" \
    --database-data-directory="${DATABASE_BASE_DATA_DIRECTORY}/${DATABASE_NAME}" \
    --manager-base-directory="$MANAGER_BASE_DIRECTORY" \
    --manager-home-directory="$MANAGER_HOME_DIRECTORY" \
    --manager-instance-directory="$MANAGER_INSTANCE_DIRECTORY" \
    --agent-base-directory="$AGENT_BASE_DIRECTORY" \
    --manager-packages-file-names="${ARCHIVE_DIR}/V1007079-01.zip, ${ARCHIVE_DIR}/V1007080-01.zip, ${ARCHIVE_DIR}/V1007081-01.zip, ${ARCHIVE_DIR}/V1007082-01.zip, ${ARCHIVE_DIR}/V1007083-01.zip" \
    --manager-omspatcher-file-name="${ARCHIVE_DIR}/p19999993_135000_Generic.zip" \
    --manager-upgrade-patch-file-name="${ARCHIVE_DIR}/p36761595_135000_Generic.zip" \
    --manager-patches-file-names="${ARCHIVE_DIR}/p31657681_191000_Generic.zip, ${ARCHIVE_DIR}/p34153238_122140_Generic.zip, ${ARCHIVE_DIR}/p35430934_122140_Generic.zip" \
    --plugin-file-name="${ARCHIVE_DIR}/V1021772-01.zip" \
    "$COMMAND" "$TARGET"
fi

exit $?
