#!/usr/bin/env bash
#------------------------------------------------------------------------------#
# Copyright (C) 2024 Nicolas De Rico                                           #
#                                                                              #
# This program is free software: you can redistribute it and/or modify it      #
# under the terms of the GNU General Public License as published by the Free   #
# Software Foundation, either version 3 of the License, or any later version.  #
#                                                                              #
# This program is distributed in the hope that it will be useful, but WITHOUT  #
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or        #
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for    #
# more details.                                                                #
#                                                                              #
# You should have received a copy of the GNU General Public License along with #
# this program.  If not, see <http://www.gnu.org/licenses/>.                   #
#------------------------------------------------------------------------------#

declare -r -i ECHO_TRACE=0

################################ Constants ################################

declare -r PROGRAM=`basename "$0"`

#######################
# Product information #
#######################

declare -r PRODUCT_DATABASE='database'
declare -r PRODUCT_MANAGER='em'
declare -r PRODUCT_AGENT='emagent'
declare -r -a PRODUCTS=(
  "$PRODUCT_DATABASE"
  "$PRODUCT_MANAGER"
  "$PRODUCT_AGENT"
)
declare -i PRODUCT_MAXIMUM_LENGTH=0
declare Option
for Option in ${PRODUCTS[@]} ; do
  if [[ ${#Option} -gt $PRODUCT_MAXIMUM_LENGTH ]] ; then
    PRODUCT_MAXIMUM_LENGTH=${#Option}
  fi
done
unset Option
declare -r -i PRODUCT_MAXIMUM_LENGTH

declare -r -A PRODUCT_DESCRIPTIONS=(
  ["$PRODUCT_DATABASE"]='Oracle Database'
  ["$PRODUCT_MANAGER"]='Oracle Enterprise Manager'
  ["$PRODUCT_AGENT"]='Oracle Enterprise Manager agent'
)

####################
# Program commands #
####################

declare -r COMMAND_HELP='help'
declare -r COMMAND_OPTIONS='options'
declare -r COMMAND_PREPARE='prepare'
declare -r COMMAND_INSTALL='install'
declare -r COMMAND_UNINSTALL='uninstall'
declare -r -a COMMANDS=(
  "$COMMAND_HELP"
  "$COMMAND_OPTIONS"
  "$COMMAND_PREPARE"
  "$COMMAND_INSTALL"
  "$COMMAND_UNINSTALL"
)

declare -i COMMAND_MAXIMUM_LENGTH=0
declare Option
for Option in ${COMMANDS[@]} ; do
  if [[ ${#Option} -gt $COMMAND_MAXIMUM_LENGTH ]] ; then
    COMMAND_MAXIMUM_LENGTH=${#Option}
  fi
done
unset Option
declare -r -i COMMAND_MAXIMUM_LENGTH

declare -r -A COMMAND_DESCRIPTIONS=(
  ["$COMMAND_HELP"]='display the program help'
  ["$COMMAND_OPTIONS"]='display the program parameters'
  ["$COMMAND_PREPARE"]='prepare the system to install the Oracle products'
  ["$COMMAND_INSTALL"]="prepare the system and install the Oracle products"
  ["$COMMAND_UNINSTALL"]="uninstall the Oracle products"
)

###################
# Program options #
###################

declare -r OPTION_PREFIX='--'
declare -r OPTION_UNKNOWN='Unknown'
declare -r OPTION_FILE_NAME='options-file-name'
declare -r OPTION_INSTALLATION_STAGE='stage'
declare -r OPTION_INSTALLATION_ROOT='installation-root'
declare -r OPTION_INSTALLATION_INVENTORY='installation-inventory'
declare -r OPTION_INSTALLATION_BASE='installation-base'
declare -r OPTION_INSTALLATION_FILE_PERMISSIONS='installation-file-permissions'
declare -r OPTION_INSTALLATION_USER='user'
declare -r OPTION_INSTALLATION_GROUP='group'
declare -r OPTION_INSTALLATION_HOSTNAME='hostname'
declare -r OPTION_DATABASE_VERSION='database-version'
declare -r OPTION_DATABASE_PACKAGE_FILE_NAME='database-package-file-name'
declare -r OPTION_DATABASE_OPATCH_FILE_NAME='database-opatch-file-name'
declare -r OPTION_DATABASE_UPGRADE_PATCH_FILE_NAME='database-upgrade-patch-file-name'
declare -r OPTION_DATABASE_RESPONSE_FILE_NAME='database-response-file-name'
declare -r OPTION_DATABASE_RESPONSE_FILE_PERMISSIONS='database-response-file-permissions'
declare -r OPTION_DATABASE_BASE='database-base'
declare -r OPTION_DATABASE_HOME='database-home'
declare -r OPTION_DATABASE_DATA='database-data'
declare -r OPTION_DATABASE_RECOVERY='database-recovery'
declare -r OPTION_DATABASE_NAME='database-name'
declare -r OPTION_DATABASE_PORT='database-port'
declare -r OPTION_DATABASE_ADMINISTRATOR_GROUP='dba-group'
declare -r OPTION_DATABASE_PASSWORD='database-password'
declare -r OPTION_MANAGER_VERSION='manager-version'
declare -r OPTION_MANAGER_PACKAGES_FILE_NAMES='manager-packages-file-names'
declare -r OPTION_MANAGER_OPATCH_FILE_NAME='manager-opatch-file-name'
declare -r OPTION_MANAGER_OMSPATCHER_FILE_NAME='manager-omspatcher-file-name'
declare -r OPTION_MANAGER_UPGRADE_PATCH_FILE_NAME='manager-upgrade-patch-file-name'
declare -r OPTION_MANAGER_PATCHES_FILE_NAMES='manager-patches-file-names'
declare -r OPTION_MANAGER_RESPONSE_FILE_NAME='manager-response-file-name'
declare -r OPTION_MANAGER_RESPONSE_FILE_PERMISSIONS='manager-response-file-permissions'
declare -r OPTION_MANAGER_BASE='manager-base'
declare -r OPTION_MANAGER_HOME='manager-home'
declare -r OPTION_MANAGER_INSTANCE='manager-instance'
declare -r OPTION_MANAGER_PORT='manager-port'
declare -r OPTION_MANAGER_PASSWORD='manager-password'
declare -r OPTION_MANAGER_KEYSTORE_FILE_NAME='keystore-file'
declare -r OPTION_MANAGER_KEYSTORE_PASSWORD='keystore-password'
declare -r OPTION_MANAGER_TRUSTSTORE_FILE_NAME='truststore-file'
declare -r OPTION_MANAGER_TRUSTSTORE_PASSWORD='truststore-password'
declare -r OPTION_AGENT_BASE='agent-base'
declare -r OPTION_AGENT_PASSWORD='agent-password'
declare -r OPTION_WEBLOGIC_PORT='weblogic-port'
declare -r OPTION_WEBLOGIC_PASSWORD='weblogic-password'
declare -r OPTION_SUDOERS_FILE_NAME='sudoers-file-name'
declare -r OPTION_SUDOERS_FILE_PERMISSIONS='sudoers-file-permissions'
declare -r OPTION_SWAP_GOAL='swap-goal'
declare -r OPTION_SWAP_FILE_NAME='swap-file-name'
declare -r OPTION_SWAP_FILE_PERMISSIONS='swap-file-permissions'
declare -r OPTION_SYSCTL_FILE_NAME='sysctl-file-name'
declare -r OPTION_SYSCTL_FILE_PERMISSIONS='sysctl-file-permissions'
declare -r OPTION_LIMITS_FILE_NAME='limits-file-name'
declare -r OPTION_LIMITS_FILE_PERMISSIONS='limits-file-permissions'
declare -r OPTION_CONTROLLER_FILE_NAME='controller-file-name'
declare -r OPTION_CONTROLLER_FILE_PERMISSIONS='controller-file-permissions'
declare -r OPTION_SYSTEMD_SERVICE='systemd-service'
declare -r OPTION_SYSTEMD_FILE_NAME='systemd-file-name'
declare -r OPTION_SYSTEMD_FILE_PERMISSIONS='systemd-file-permissions'

# Option display sorted order

declare -r -a OPTIONS=(
  "$OPTION_FILE_NAME"
  "$OPTION_INSTALLATION_STAGE"
  "$OPTION_INSTALLATION_ROOT"
  "$OPTION_INSTALLATION_INVENTORY"
  "$OPTION_INSTALLATION_BASE"
  "$OPTION_INSTALLATION_FILE_PERMISSIONS"
  "$OPTION_INSTALLATION_USER"
  "$OPTION_INSTALLATION_GROUP"
  "$OPTION_INSTALLATION_HOSTNAME"
  "$OPTION_DATABASE_VERSION"
  "$OPTION_DATABASE_PACKAGE_FILE_NAME"
  "$OPTION_DATABASE_OPATCH_FILE_NAME"
  "$OPTION_DATABASE_UPGRADE_PATCH_FILE_NAME"
  "$OPTION_DATABASE_RESPONSE_FILE_NAME"
  "$OPTION_DATABASE_RESPONSE_FILE_PERMISSIONS"
  "$OPTION_DATABASE_BASE"
  "$OPTION_DATABASE_HOME"
  "$OPTION_DATABASE_DATA"
  "$OPTION_DATABASE_RECOVERY"
  "$OPTION_DATABASE_NAME"
  "$OPTION_DATABASE_PORT"
  "$OPTION_DATABASE_ADMINISTRATOR_GROUP"
  "$OPTION_DATABASE_PASSWORD"
  "$OPTION_MANAGER_VERSION"
  "$OPTION_MANAGER_PACKAGES_FILE_NAMES"
  "$OPTION_MANAGER_OPATCH_FILE_NAME"
  "$OPTION_MANAGER_OMSPATCHER_FILE_NAME"
  "$OPTION_MANAGER_RESPONSE_FILE_NAME"
  "$OPTION_MANAGER_RESPONSE_FILE_PERMISSIONS"
  "$OPTION_MANAGER_BASE"
  "$OPTION_MANAGER_HOME"
  "$OPTION_MANAGER_INSTANCE"
  "$OPTION_MANAGER_PORT"
  "$OPTION_MANAGER_PASSWORD"
  "$OPTION_MANAGER_KEYSTORE_FILE_NAME"
  "$OPTION_MANAGER_KEYSTORE_PASSWORD"
  "$OPTION_MANAGER_TRUSTSTORE_FILE_NAME"
  "$OPTION_MANAGER_TRUSTSTORE_PASSWORD"
  "$OPTION_AGENT_BASE"
  "$OPTION_AGENT_PASSWORD"
  "$OPTION_WEBLOGIC_PORT"
  "$OPTION_WEBLOGIC_PASSWORD"
  "$OPTION_SUDOERS_FILE_NAME"
  "$OPTION_SUDOERS_FILE_PERMISSIONS"
  "$OPTION_SWAP_GOAL"
  "$OPTION_SWAP_FILE_NAME"
  "$OPTION_SWAP_FILE_PERMISSIONS"
  "$OPTION_SYSCTL_FILE_NAME"
  "$OPTION_SYSCTL_FILE_PERMISSIONS"
  "$OPTION_LIMITS_FILE_NAME"
  "$OPTION_LIMITS_FILE_PERMISSIONS"
  "$OPTION_CONTROLLER_FILE_NAME"
  "$OPTION_CONTROLLER_FILE_PERMISSIONS"
  "$OPTION_SYSTEMD_SERVICE"
  "$OPTION_SYSTEMD_FILE_NAME"
  "$OPTION_SYSTEMD_FILE_PERMISSIONS"
)

declare -i OPTION_MAXIMUM_LENGTH=0
declare Option
for Option in ${OPTIONS[@]} ; do
  if [[ ${#Option} -gt $OPTION_MAXIMUM_LENGTH ]] ; then
    OPTION_MAXIMUM_LENGTH=${#Option}
  fi
done
unset Option
declare -r -i OPTION_MAXIMUM_LENGTH

declare -i HELP_PADDING_LENGTH=$((OPTION_MAXIMUM_LENGTH + ${#OPTION_PREFIX}))
if [[ $COMMAND_MAXIMUM_LENGTH -gt $HELP_PADDING_LENGTH ]] ; then
  HELP_PADDING_LENGTH=$COMMAND_MAXIMUM_LENGTH
fi
if [[ $PRODUCT_MAXIMUM_LENGTH -gt $HELP_PADDING_LENGTH ]] ; then
  HELP_PADDING_LENGTH=$PRODUCT_MAXIMUM_LENGTH
fi
declare -r -i HELP_PADDING_LENGTH

# Option sources

declare -r -i OPTION_SOURCE_UNSET=0
declare -r -i OPTION_SOURCE_PROGRAM=1
declare -r -i OPTION_SOURCE_COMMAND=$((OPTION_SOURCE_PROGRAM * 2))
declare -r -i OPTION_SOURCE_FILE=$((OPTION_SOURCE_COMMAND * 2))
declare -r -i OPTION_SOURCE_BOTH=$((OPTION_SOURCE_COMMAND + $OPTION_SOURCE_FILE))
declare -r -i OPTION_SOURCE_ALL=$((OPTION_SOURCE_PROGRAM + $OPTION_SOURCE_BOTH))
declare -r -a OPTION_SOURCE_NAMES=(
  [$OPTION_SOURCE_PROGRAM]='program'
  [$OPTION_SOURCE_COMMAND]='command'
  [$OPTION_SOURCE_FILE]='file'
)

declare -r -A -i OPTION_SOURCES=(
  ["$OPTION_FILE_NAME"]=$OPTION_SOURCE_COMMAND
  ["$OPTION_INSTALLATION_STAGE"]=$OPTION_SOURCE_ALL
  ["$OPTION_INSTALLATION_ROOT"]=$OPTION_SOURCE_ALL
  ["$OPTION_INSTALLATION_INVENTORY"]=$OPTION_SOURCE_ALL
  ["$OPTION_INSTALLATION_BASE"]=$OPTION_SOURCE_ALL
  ["$OPTION_INSTALLATION_FILE_PERMISSIONS"]=$OPTION_SOURCE_PROGRAM
  ["$OPTION_INSTALLATION_USER"]=$OPTION_SOURCE_ALL
  ["$OPTION_INSTALLATION_GROUP"]=$OPTION_SOURCE_ALL
  ["$OPTION_INSTALLATION_HOSTNAME"]=$OPTION_SOURCE_PROGRAM
  ["$OPTION_DATABASE_VERSION"]=$OPTION_SOURCE_ALL
  ["$OPTION_DATABASE_PACKAGE_FILE_NAME"]=$OPTION_SOURCE_ALL
  ["$OPTION_DATABASE_OPATCH_FILE_NAME"]=$OPTION_SOURCE_ALL
  ["$OPTION_DATABASE_UPGRADE_PATCH_FILE_NAME"]=$OPTION_SOURCE_ALL
  ["$OPTION_DATABASE_RESPONSE_FILE_NAME"]=$OPTION_SOURCE_ALL
  ["$OPTION_DATABASE_RESPONSE_FILE_PERMISSIONS"]=$OPTION_SOURCE_ALL
  ["$OPTION_DATABASE_BASE"]=$OPTION_SOURCE_ALL
  ["$OPTION_DATABASE_HOME"]=$OPTION_SOURCE_ALL
  ["$OPTION_DATABASE_DATA"]=$OPTION_SOURCE_ALL
  ["$OPTION_DATABASE_RECOVERY"]=$OPTION_SOURCE_ALL
  ["$OPTION_DATABASE_NAME"]=$OPTION_SOURCE_ALL
  ["$OPTION_DATABASE_PORT"]=$OPTION_SOURCE_ALL
  ["$OPTION_DATABASE_ADMINISTRATOR_GROUP"]=$OPTION_SOURCE_ALL
  ["$OPTION_DATABASE_PASSWORD"]=$OPTION_SOURCE_FILE
  ["$OPTION_MANAGER_VERSION"]=$OPTION_SOURCE_ALL
  ["$OPTION_MANAGER_PACKAGES_FILE_NAMES"]=$OPTION_SOURCE_ALL
  ["$OPTION_MANAGER_OPATCH_FILE_NAME"]=$OPTION_SOURCE_ALL
  ["$OPTION_MANAGER_OMSPATCHER_FILE_NAME"]=$OPTION_SOURCE_ALL
  ["$OPTION_MANAGER_UPGRADE_PATCH_FILE_NAME"]=$OPTION_SOURCE_ALL
  ["$OPTION_MANAGER_PATCHES_FILE_NAMES"]=$OPTION_SOURCE_ALL
  ["$OPTION_MANAGER_RESPONSE_FILE_NAME"]=$OPTION_SOURCE_ALL
  ["$OPTION_MANAGER_RESPONSE_FILE_PERMISSIONS"]=$OPTION_SOURCE_ALL
  ["$OPTION_MANAGER_BASE"]=$OPTION_SOURCE_ALL
  ["$OPTION_MANAGER_HOME"]=$OPTION_SOURCE_ALL
  ["$OPTION_MANAGER_INSTANCE"]=$OPTION_SOURCE_ALL
  ["$OPTION_MANAGER_PORT"]=$OPTION_SOURCE_ALL
  ["$OPTION_MANAGER_PASSWORD"]=$OPTION_SOURCE_FILE
  ["$OPTION_MANAGER_KEYSTORE_FILE_NAME"]=$OPTION_SOURCE_ALL
  ["$OPTION_MANAGER_KEYSTORE_PASSWORD"]=$OPTION_SOURCE_FILE
  ["$OPTION_MANAGER_TRUSTSTORE_FILE_NAME"]=$OPTION_SOURCE_ALL
  ["$OPTION_MANAGER_TRUSTSTORE_PASSWORD"]=$OPTION_SOURCE_FILE
  ["$OPTION_AGENT_BASE"]=$OPTION_SOURCE_ALL
  ["$OPTION_AGENT_PASSWORD"]=$OPTION_SOURCE_FILE
  ["$OPTION_WEBLOGIC_PORT"]=$OPTION_SOURCE_ALL
  ["$OPTION_WEBLOGIC_PASSWORD"]=$OPTION_SOURCE_FILE
  ["$OPTION_SUDOERS_FILE_NAME"]=$OPTION_SOURCE_ALL
  ["$OPTION_SUDOERS_FILE_PERMISSIONS"]=$OPTION_SOURCE_PROGRAM
  ["$OPTION_SWAP_GOAL"]=$OPTION_SOURCE_PROGRAM
  ["$OPTION_SWAP_FILE_NAME"]=$OPTION_SOURCE_ALL
  ["$OPTION_SWAP_FILE_PERMISSIONS"]=$OPTION_SOURCE_PROGRAM
  ["$OPTION_SYSCTL_FILE_NAME"]=$OPTION_SOURCE_ALL
  ["$OPTION_SYSCTL_FILE_PERMISSIONS"]=$OPTION_SOURCE_PROGRAM
  ["$OPTION_LIMITS_FILE_NAME"]=$OPTION_SOURCE_ALL
  ["$OPTION_LIMITS_FILE_PERMISSIONS"]=$OPTION_SOURCE_PROGRAM
  ["$OPTION_CONTROLLER_FILE_NAME"]=$OPTION_SOURCE_ALL
  ["$OPTION_CONTROLLER_FILE_PERMISSIONS"]=$OPTION_SOURCE_PROGRAM
  ["$OPTION_SYSTEMD_SERVICE"]=$OPTION_SOURCE_ALL
  ["$OPTION_SYSTEMD_FILE_NAME"]=$OPTION_SOURCE_ALL
  ["$OPTION_SYSTEMD_FILE_PERMISSIONS"]=$OPTION_SOURCE_PROGRAM
)

# Optional options

declare -r -A OPTIONS_OPTIONAL=(
  ["$OPTION_DATABASE_OPATCH_FILE_NAME"]='x'
  ["$OPTION_DATABASE_UPGRADE_PATCH_FILE_NAME"]='x'
  ["$OPTION_MANAGER_OPATCH_FILE_NAME"]='x'
  ["$OPTION_MANAGER_OMSPATCHER_FILE_NAME"]='x'
  ["$OPTION_MANAGER_UPGRADE_PATCH_FILE_NAME"]='x'
  ["$OPTION_MANAGER_PATCHES_FILE_NAMES"]='x'
)

# Option default values

declare -r DEFAULT_SYSTEMD_SERVICE_NAME='dbora.service'
declare -r DEFAULT_PASSWORD='Abcd_1234'

declare -r -A OPTION_DEFAULT_VALUES=(
  ["$OPTION_INSTALLATION_ROOT"]='/u01/app'
  ["$OPTION_INSTALLATION_FILE_PERMISSIONS"]='755'
  ["$OPTION_INSTALLATION_USER"]='oracle'
  ["$OPTION_INSTALLATION_GROUP"]='oinstall'
  ["$OPTION_INSTALLATION_HOSTNAME"]=`hostname -f`
  ["$OPTION_DATABASE_VERSION"]='19.3.0.0.0'
  ["$OPTION_DATABASE_RESPONSE_FILE_NAME"]='/tmp/db_install.rsp'
  ["$OPTION_DATABASE_RESPONSE_FILE_PERMISSIONS"]='640'
  ["$OPTION_DATABASE_NAME"]='emrep'
  ["$OPTION_DATABASE_PORT"]='1521'
  ["$OPTION_DATABASE_ADMINISTRATOR_GROUP"]='dba'
  ["$OPTION_DATABASE_PASSWORD"]="$DEFAULT_PASSWORD"
  ["$OPTION_MANAGER_VERSION"]='13.5.0.0.0'
  ["$OPTION_MANAGER_RESPONSE_FILE_NAME"]='/tmp/em_install.rsp'
  ["$OPTION_MANAGER_RESPONSE_FILE_PERMISSIONS"]='640'
  ["$OPTION_MANAGER_PORT"]='7803'
  ["$OPTION_MANAGER_PASSWORD"]="$DEFAULT_PASSWORD"
  ["$OPTION_MANAGER_KEYSTORE_PASSWORD"]="$DEFAULT_PASSWORD"
  ["$OPTION_MANAGER_TRUSTSTORE_PASSWORD"]="$DEFAULT_PASSWORD"
  ["$OPTION_AGENT_PASSWORD"]="$DEFAULT_PASSWORD"
  ["$OPTION_WEBLOGIC_PORT"]='7102'
  ["$OPTION_WEBLOGIC_PASSWORD"]="$DEFAULT_PASSWORD"
  ["$OPTION_SUDOERS_FILE_NAME"]='/etc/sudoers.d/101-oracle-user'
  ["$OPTION_SUDOERS_FILE_PERMISSIONS"]='440'
  ["$OPTION_SWAP_GOAL"]=16
  ["$OPTION_SWAP_FILE_NAME"]='/.swapfile_oem'
  ["$OPTION_SWAP_FILE_PERMISSIONS"]='600'
  ["$OPTION_SYSCTL_FILE_NAME"]='/etc/sysctl.d/98-oracle.conf'
  ["$OPTION_SYSCTL_FILE_PERMISSIONS"]='644'
  ["$OPTION_LIMITS_FILE_NAME"]='/etc/security/limits.d/oracle-database-preinstall-19c.conf'
  ["$OPTION_LIMITS_FILE_PERMISSIONS"]='644'
  ["$OPTION_CONTROLLER_FILE_NAME"]='servicectl.sh'
  ["$OPTION_CONTROLLER_FILE_PERMISSIONS"]='740'
  ["$OPTION_SYSTEMD_SERVICE"]="$DEFAULT_SYSTEMD_SERVICE_NAME"
  ["$OPTION_SYSTEMD_FILE_NAME"]="/lib/systemd/system/${DEFAULT_SYSTEMD_SERVICE_NAME}"
  ["$OPTION_SYSTEMD_FILE_PERMISSIONS"]='644'
)

# Option descriptions

declare -r DESCRIPTION_SUDOERS_FILE="installation system user sudoers definition file"
declare -r DESCRIPTION_SWAP='system swap'
declare -r DESCRIPTION_SWAP_FILE="additional file for the ${DESCRIPTION_SWAP}"
declare -r DESCRIPTION_SYSCTL="Systemctl settings for the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]}"
declare -r DESCRIPTION_SYSCTL_FILE="definition file for the ${DESCRIPTION_SYSCTL}"
declare -r DESCRIPTION_LIMITS="system limits settings for the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]}"
declare -r DESCRIPTION_LIMITS_FILE="definition file for the ${DESCRIPTION_LIMITS}"
declare -r DESCRIPTION_CONTROLLER='service controller for the Oracle products'
declare -r DESCRIPTION_CONTROLLER_FILE="program file for ${DESCRIPTION_CONTROLLER}"
declare -r DESCRIPTION_SYSTEMD_SERVICE='Systemd service for the Oracle products'
declare -r DESCRIPTION_SYSTEMD_SERVICE_FILE="definition file for the ${DESCRIPTION_SYSTEMD_SERVICE}"
declare -r DESCRIPTION_DATABASE_PACKAGE_FILE="${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} software package zip file"
declare -r DESCRIPTION_DATABASE_OPATCH="${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} OPatch utility"
declare -r DESCRIPTION_DATABASE_OPATCH_HOME="home of the ${DESCRIPTION_DATABASE_OPATCH}"
declare -r DESCRIPTION_DATABASE_OPATCH_FILE="${DESCRIPTION_DATABASE_OPATCH} update zip file"
declare -r DESCRIPTION_DATABASE_UPGRADE_PATCH="${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} version patch update"
declare -r DESCRIPTION_DATABASE_UPGRADE_PATCH_FILE="${DESCRIPTION_DATABASE_UPGRADE_PATCH} zip file"
declare -r DESCRIPTION_DATABASE_RESPONSE_FILE="${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} installation response file"
declare -r DESCRIPTION_MANAGER_FILE="${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} installation zip file"
declare -r DESCRIPTION_MANAGER_FILES="installation zip files for the ${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]}"
declare -r DESCRIPTION_MANAGER_OPATCH="${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} OPatch utility"
declare -r DESCRIPTION_MANAGER_OPATCH_HOME="home of the ${DESCRIPTION_MANAGER_OPATCH}"
declare -r DESCRIPTION_MANAGER_OPATCH_FILE="${DESCRIPTION_MANAGER_OPATCH} update zip file"
declare -r DESCRIPTION_MANAGER_OMSPATCHER="${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} OMS patcher utility"
declare -r DESCRIPTION_MANAGER_OMSPATCHER_HOME="home of the ${DESCRIPTION_MANAGER_OMSPATCHER}"
declare -r DESCRIPTION_MANAGER_OMSPATCHER_FILE="${DESCRIPTION_MANAGER_OMSPATCHER} update zip file"
declare -r DESCRIPTION_MANAGER_UPGRADE_PATCH="${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} patch update"
declare -r DESCRIPTION_MANAGER_UPGRADE_PATCH_FILE="${DESCRIPTION_MANAGER_UPGRADE_PATCH} zip file"
declare -r DESCRIPTION_MANAGER_PATCH="${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} patch"
declare -r DESCRIPTION_MANAGER_PATCH_FILE="${DESCRIPTION_MANAGER_PATCH} zip file"
declare -r DESCRIPTION_MANAGER_PATCH_FILES="zip files for the ${DESCRIPTION_MANAGER_PATCH}s"
declare -r DESCRIPTION_MANAGER_RESPONSE_FILE="${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} installation response file"
declare -r DESCRIPTION_MANAGER_KEYSTORE="${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} key store"
declare -r DESCRIPTION_MANAGER_KEYSTORE_FILE="${DESCRIPTION_MANAGER_KEYSTORE} file"
declare -r DESCRIPTION_MANAGER_TRUSTSTORE="${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} trust store"
declare -r DESCRIPTION_MANAGER_TRUSTSTORE_FILE="${DESCRIPTION_MANAGER_TRUSTSTORE} file"

declare -r -A OPTION_DESCRIPTIONS=(
  ["$OPTION_FILE_NAME"]='name of an optional file that contains options to override the default option values of this program'
  ["$OPTION_INSTALLATION_ROOT"]='Oracle installation root directory'
  ["$OPTION_INSTALLATION_STAGE"]='staging (de-)installation directory'
  ["$OPTION_INSTALLATION_INVENTORY"]='Oracle inventory directory'
  ["$OPTION_INSTALLATION_FILE_PERMISSIONS"]='file permissions of the Oracle installation'
  ["$OPTION_INSTALLATION_BASE"]='Oracle installation base directory'
  ["$OPTION_INSTALLATION_USER"]='installation system user'
  ["$OPTION_INSTALLATION_GROUP"]='installation system group'
  ["$OPTION_INSTALLATION_HOSTNAME"]='host name'
  ["$OPTION_DATABASE_VERSION"]="${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} version"
  ["$OPTION_DATABASE_PACKAGE_FILE_NAME"]="name of the ${DESCRIPTION_DATABASE_PACKAGE_FILE}"
  ["$OPTION_DATABASE_OPATCH_FILE_NAME"]="name of the ${DESCRIPTION_DATABASE_OPATCH_FILE}"
  ["$OPTION_DATABASE_UPGRADE_PATCH_FILE_NAME"]="name of the ${DESCRIPTION_DATABASE_UPGRADE_PATCH_FILE}"
  ["$OPTION_DATABASE_RESPONSE_FILE_NAME"]="name of the ${DESCRIPTION_DATABASE_RESPONSE_FILE}"
  ["$OPTION_DATABASE_RESPONSE_FILE_PERMISSIONS"]="file permissions on the ${DESCRIPTION_DATABASE_RESPONSE_FILE}"
  ["$OPTION_DATABASE_BASE"]="${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} base directory"
  ["$OPTION_DATABASE_HOME"]="${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} home directory"
  ["$OPTION_DATABASE_DATA"]="${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} data directory"
  ["$OPTION_DATABASE_RECOVERY"]="${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} recovery directory"
  ["$OPTION_DATABASE_NAME"]="${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} name"
  ["$OPTION_DATABASE_PORT"]="${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} listener network port"
  ["$OPTION_DATABASE_ADMINISTRATOR_GROUP"]="${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} administrator system group"
  ["$OPTION_DATABASE_PASSWORD"]="${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} sys account password"
  ["$OPTION_MANAGER_VERSION"]="${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} version"
  ["$OPTION_MANAGER_PACKAGES_FILE_NAMES"]="names of the ${DESCRIPTION_MANAGER_FILES}"
  ["$OPTION_MANAGER_OPATCH_FILE_NAME"]="names of the ${DESCRIPTION_MANAGER_OPATCH_FILE}"
  ["$OPTION_MANAGER_OMSPATCHER_FILE_NAME"]="names of the ${DESCRIPTION_MANAGER_OMSPATCHER_FILE}"
  ["$OPTION_MANAGER_UPGRADE_PATCH_FILE_NAME"]="name of the ${DESCRIPTION_NAME_UPGRADE_PATCH_FILE}"
  ["$OPTION_MANAGER_PATCHES_FILE_NAMES"]="names of the ${DESCRIPTION_MANAGER_PATCH_FILES}"
  ["$OPTION_MANAGER_RESPONSE_FILE_NAME"]="name of the ${DESCRIPTION_MANAGER_RESPONSE_FILE}"
  ["$OPTION_MANAGER_RESPONSE_FILE_PERMISSIONS"]="file permissions on the ${DESCRIPTION_MANAGER_RESPONSE_FILE}"
  ["$OPTION_MANAGER_BASE"]="${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} base directory"
  ["$OPTION_MANAGER_HOME"]="${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} home directory"
  ["$OPTION_MANAGER_INSTANCE"]="${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} instance home directory"
  ["$OPTION_MANAGER_PORT"]="${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} network port"
  ["$OPTION_MANAGER_PASSWORD"]="${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} sysman account password"
  ["$OPTION_MANAGER_KEYSTORE_FILE_NAME"]="name of the ${OPTION_MANAGER_KEYSTORE_FILE}"
  ["$OPTION_MANAGER_KEYSTORE_PASSWORD"]="password for the ${OPTION_MANAGER_KEYSTORE_FILE}"
  ["$OPTION_MANAGER_TRUSTSTORE_FILE_NAME"]="name of the ${OPTION_MANAGER_TRUSTSTORE_FILE}"
  ["$OPTION_MANAGER_TRUSTSTORE_PASSWORD"]="password for the ${OPTION_MANAGER_TRUSTSTORE_FILE}"
  ["$OPTION_AGENT_BASE"]="${PRODUCT_DESCRIPTIONS[${PRODUCT_AGENT}]} base directory"
  ["$OPTION_AGENT_PASSWORD"]="${PRODUCT_DESCRIPTIONS[${PRODUCT_AGENT}]} account password"
  ["$OPTION_WEBLOGIC_PORT"]='Weblogic administration port'
  ["$OPTION_WEBLOGIC_PASSWORD"]='Weblogic account password'
  ["$OPTION_SUDOERS_FILE_NAME"]="name of the ${DESCRIPTION_SUDOERS_FILE}"
  ["$OPTION_SUDOERS_FILE_PERMISSIONS"]="file permissions on the ${DESCRIPTION_SUDOERS_FILE}"
  ["$OPTION_SWAP_GOAL"]="desired size of the ${DESCRIPTION_SWAP}"
  ["$OPTION_SWAP_FILE_NAME"]="name of the ${DESCRIPTION_SWAP_FILE}"
  ["$OPTION_SWAP_FILE_PERMISSIONS"]="file permissions of the ${DESCRIPTION_SWAP_FILE}"
  ["$OPTION_SYSCTL_FILE_NAME"]="name of the ${DESCRIPTION_SYSCTL_FILE}"
  ["$OPTION_SYSCTL_FILE_PERMISSIONS"]="file permissions on the ${DESCRIPTION_SYSCTL_FILE}"
  ["$OPTION_LIMITS_FILE_NAME"]="name of the ${DESCRIPTION_LIMITS_FILE}"
  ["$OPTION_LIMITS_FILE_PERMISSIONS"]="file permissions on the ${DESCRIPTION_LIMITS_FILE}"
  ["$OPTION_CONTROLLER_FILE_NAME"]="name of the ${DESCRIPTION_CONTROLLER_FILE}"
  ["$OPTION_CONTROLLER_FILE_PERMISSIONS"]="file permissions on the ${DESCRIPTION_CONTROLLER_FILE}"
  ["$OPTION_SYSTEMD_SERVICE"]="name of the $DESCRIPTION_SYSTEMD_SERVICE"
  ["$OPTION_SYSTEMD_FILE_NAME"]="name of the ${DESCRIPTION_SYSTEMD_SERVICE_FILE}"
  ["$OPTION_SYSTEMD_FILE_PERMISSIONS"]="file permissions on the ${DESCRIPTION_SYSTEMD_SERVICE_FILE}"
)

declare -i OPTION_DESCRIPTION_MAXIMUM_LENGTH=0
declare Option
for Option in ${OPTIONS[@]} ; do
  if [[ ${#OPTION_DESCRIPTIONS[${Option}]} -gt $OPTION_DESCRIPTION_MAXIMUM_LENGTH ]] ; then
    OPTION_DESCRIPTION_MAXIMUM_LENGTH=${#OPTION_DESCRIPTIONS[${Option}]}
  fi
done
unset Option
declare -i -r OPTION_DESCRIPTION_MAXIMUM_LENGTH

#########################
# Return code constants #
#########################

declare -r -i RETCODE_SUCCESS=0
declare -r -i RETCODE_OPERATION_ERROR=1
declare -r -i RETCODE_PARAMETER_ERROR=2
declare -r -i RETCODE_INTERNAL_ERROR=100

###################
# Other constants #
###################

declare -r CHARACTER_SINGLE_QUOTE="'"
declare -r CHARACTER_DOUBLE_QUOTE="\""
declare -r CHARACTER_BACKSLASH='\'
declare -r -i VALUE_TRUE=0
declare -r -i VALUE_FALSE=1
declare -r -i HELP_INDENT_LENGTH=2
declare -r ORATAB_FILE_NAME='/etc/oratab'
declare -r FSTAB_FILE_NAME='/etc/fstab'

################################ Utility functions ################################

################################################################################
## @fn echoSourceName
##
## @brief Echo the name(s) of the source.
##
## @param[in] Source The source for which to echo the name, or names if the
##                   value refers to multiple sources.
##
## @return RETCODE_SUCCESS
################################################################################
echoSourceName() {
  local -r -i Source=${1:-$OPTION_SOURCE_UNSET}
  if [[ $OPTION_SOURCE_ALL -eq $Source ]] ; then
    echo "${OPTION_SOURCE_NAMES[${OPTION_SOURCE_COMMAND}]}, ${OPTION_SOURCE_NAMES[${OPTION_SOURCE_FILE}]}, ${OPTION_SOURCE_NAMES[${OPTION_SOURCE_PROGRAM}]}"
  elif [[ $OPTION_SOURCE_BOTH -eq $Source ]] ; then
    echo "${OPTION_SOURCE_NAMES[${OPTION_SOURCE_COMMAND}]}, ${OPTION_SOURCE_NAMES[${OPTION_SOURCE_FILE}]}"
  elif [[ $OPTION_SOURCE_COMMAND -eq $Source ]] || [[ $OPTION_SOURCE_FILE -eq $Source ]] || [[ $OPTION_SOURCE_PROGRAM -eq $Source ]] ; then
    echo "${OPTION_SOURCE_NAMES[${Source}]}"
  else
    echo ''
  fi
  return $RETCODE_SUCCESS
}

################################################################################
## @fn echoCommand
##
## @brief Echo a shell command and its parameters.
##
## @param[in] ... The command and its parameters.
##
## @return RETCODE_SUCCESS
################################################################################
echoCommand() {
  echo "$@"
  return $RETCODE_SUCCESS
}

################################################################################
## @fn echoCommandMessage
##
## @brief Echo a command completion notice message.
##
## @param[in] Message   The message to echo.
## @param[in] Parameter An optional parameter for the message that will be
##                      displayed between single-quotes.
##
## @return RETCODE_SUCCESS
################################################################################
echoCommandMessage() {
  local -r Message="${1:-}"
  local -r Parameter="${2:-}"
  if [[ -n "$Message" ]] ; then
    if [[ -n "$Parameter" ]] ; then
      echo "...${Message^}:" "'${Parameter}'"
    else
      echo "...${Message^}"
    fi
  fi
  return $RETCODE_SUCCESS
}

################################################################################
## @fn echoCommandSuccess
##
## @brief Echo a message that indicates the successful completion of a command.
##
## @return RETCODE_SUCCESS
################################################################################
echoCommandSuccess() {
  echoCommandMessage 'success'
  return $?
}

################################################################################
## @fn echoError
##
## @brief Echo an error message and return the return code.
##
## @param[in] Retcode    The return code.
## @param[in] Message    The message to echo.
## @param[in] Parameter1 An optional parameter for the message that will be
##                       displayed between single-quotes.
## @param[in] Parameter2 A second optional parameter for the message that will
##                       be displayed between parenthesis.
##
## @return The return code.
################################################################################
echoError() {
  local -r DEFAULT_MESSAGE='Unexpected error'
  local -r -i Retcode=${1:-$RETCODE_INTERNAL_ERROR}
  local -r Message="${2:-${DEFAULT_MESSAGE}}"
  local -r Parameter1="${3:-}"
  local -r Parameter2="${4:-}"
  if [[ $RETCODE_SUCCESS -ne $Retcode ]] ; then
    if [[ -n "$Parameter2" ]] ; then
      if [[ -n "$Parameter1" ]] ; then
        echo "[ERROR] ${Message^}:" "'${Parameter1}'" "(${Parameter2})"
      else
        echo "[ERROR] ${Message^}" "(${Parameter2})"
      fi
    elif [[ -n "$Parameter1" ]] ; then
      echo "[ERROR] ${Message^}:" "'${Parameter1}'"
    else
      echo "[ERROR] ${Message^}"
    fi
  fi
  return $Retcode
}

################################################################################
## @fn echoHelpItem
##
## @brief Echo the description of a program help item command formatted for the
##        help command.
##
## @param[in] _Descriptions The array of descriptions relative to the item.
## @param[in] Item          The program item for which to echo the help
##                          description.
## @param[in] Prefix        An optional prefix to use for the item.
## @param[in] SourceName    An optional source name for the item.
## @param[in] DefaultValue  An optional default value for the item.
##
## @return RETCODE_SUCCESS
################################################################################
echoHelpItem() {
  local -n _Descriptions="$1"
  local -r Item="${2:-}"
  local -r Description="${_Descriptions[${Item}]}"
  local -r Prefix="${3:-}"
  local -r SourceName="${4:-}"
  local -r DefaultValue="${5:-}"
  if [[ -n "$Item" ]] ; then
    local -r -i Padding=$(($HELP_PADDING_LENGTH - ${#Item} - ${#Prefix}))
    printf ' %.0s' $(seq 1 $HELP_INDENT_LENGTH)
    printf '%s%s: ' "$Prefix" "$Item"
    if [[ 0 -lt $Padding ]] ; then
      printf ' %.0s' $(seq 1 $Padding)
    fi
    printf '%s' "${Description^}"
    if [[ -n "$SourceName" ]] || [[ -n "$DefaultValue" ]] ; then
      if [[ -n "$SourceName" ]] && [[ -n "$DefaultValue" ]] ; then
        printf ' (source: %s; default=%s)' "$SourceName" "$DefaultValue"
      elif [[ -n "$SourceName" ]] ; then
        printf ' (source: %s)' "$SourceName"
      elif [[ -n "$DefaultValue" ]] ; then
        printf ' (default=%s)' "$DefaultValue"
      fi
    fi
    echo
  fi
  return $RETCODE_SUCCESS
}

################################################################################
## @fn echoHelp
##
## @brief Echo the program help.
##
## @param[in] bComplete Whether to display the complete help or only the usage
##                      portion (FALSE: Usage only, TRUE: Complete help)
##
## @return RETCODE_SUCCESS
################################################################################
echoHelp() {
  local -r -i bComplete=${1:-$VALUE_FALSE}
  local Item
  echo "Usage: ${PROGRAM} [options...] < Command > [ Product ]"
  echo "A utility script to install and uninstall the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} and the ${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]}."
  echo
  echo 'Commands:'
  for Item in "${COMMANDS[@]}" ; do
    echoHelpItem 'COMMAND_DESCRIPTIONS' "$Item"
  done
  echo
  echo "Products (only for the commands ${COMMAND_INSTALL} and ${COMMAND_UNINSTALL}, when no target provided specifies all products):"
  for Item in "${PRODUCTS[@]}" ; do
    echoHelpItem 'PRODUCT_DESCRIPTIONS' "$Item"
  done
  echo
  echo 'Options:'
  for Item in "${OPTIONS[@]}" ; do
    if [[ $((OPTION_SOURCE_COMMAND & ${OPTION_SOURCES[$Item]})) -eq $OPTION_SOURCE_COMMAND ]] ; then
      echoHelpItem 'OPTION_DESCRIPTIONS' "$Item" "$OPTION_PREFIX" "$(echoSourceName ${OPTION_SOURCES[${Item}]})" "${OPTION_DEFAULT_VALUES[${Item}]}"
    fi
  done
  echo
  if [[ $VALUE_TRUE -eq $bComplete ]] ; then
    echo 'Summary:'
    echo "This program is designed for the simplified installation and uninstallation of ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} 19c and ${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} 13cc on Oracle Linux 8.  A new Oracle Database instance is launched during the install process for immediate use by ${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]}.  The installation is standardized without many options and is not designed to be bullet-proof."
    echo
    echo 'Detailed description:'
    echo "The Oracle software must be procured and provided to this program, by aid of the various program options listed above, as zip files downloaded from Oracle eDelivery or My Oracle Support.  The program installs the Oracle products in their respective home directories, the structure of which follows the guidelines of the Oracle Optimal Flexible Architecture (OFA) standard.  The installation of the Oracle software is performed using the ${OPTION_DESCRIPTIONS[${OPTION_INSTALLATION_USER}]} and the ${OPTION_DESCRIPTIONS[${OPTION_INSTALLATION_GROUP}]}.  If these ${OPTION_DESCRIPTIONS[${OPTION_INSTALLATION_USER}]} and ${OPTION_DESCRIPTIONS[${OPTION_INSTALLATION_GROUP}]} do not already exist on the system, the program automatically creates them.  The ${OPTION_DESCRIPTIONS[${OPTION_INSTALLATION_USER}]} is also automatically added to the operating system list of Sudoers, if it is not already in this list.  Many system settings are automatically adjusted as per the requirements of the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]}.  The installation process is fully automated by use of the silent installer options of the Oracle software."
    echo
    echo 'Installation steps:'
    echo '1- Configure a machine that meets the minimum requirements listed below.'
    echo "2- Download the ${DESCRIPTION_DATABASE_PACKAGE_FILE} from https://edelivery.oracle.com or from https://support.oracle.com.  The zip file must be provided to the program with the options '${OPTION_DATABASE_PACKAGE_FILE_NAME}'."
    echo "3- Download the latest ${DESCRIPTION_DATABASE_OPATCH_FILE} and ${DESCRIPTION_DATABASE_UPGRADE_PATCH_FILE}, and provide them to the program with the options '${OPTION_DATABASE_OPATCH_FILE_NAME}' and '${OPTION_DATABASE_UPGRADE_PATCH_FILE_NAME}', respectively."
    echo "4- Download the ${DESCRIPTION_MANAGER_FILES} from https://edelivery.oracle.com or from https://support.oracle.com.  There should be five zip files, which must be provided to the program as a comma-separated list with the parameter '${OPTION_MANAGER_PACKAGES_FILE_NAMES}'."
    echo "5- Run this program with the '${COMMAND_INSTALL}' command with the necessary program parameters.  For example, to install the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]}:"
    echo "       ${PROGRAM} ${CHARACTER_BACKSLASH}"
    echo "           ${OPTION_PREFIX}${OPTION_DATABASE_PACKAGE_FILE_NAME}=${OPTION_DEFAULT_VALUES[${OPTION_DATABASE_PACKAGE_FILE_NAME}]} ${CHARACTER_BACKSLASH}"
    echo "           ${OPTION_PREFIX}${OPTION_DATABASE_OPATCH_FILE_NAME}=${OPTION_DEFAULT_VALUES[${OPTION_DATABASE_OPATCH_FILE_NAME}]} ${CHARACTER_BACKSLASH}"
    echo "           ${OPTION_PREFIX}${OPTION_DATABASE_UPGRADE_PATCH_FILE_NAME}=${OPTION_DEFAULT_VALUES[${OPTION_DATABASE_UPGRADE_PATCH_FILE_NAME}]} ${CHARACTER_BACKSLASH}"
    echo "           ${COMMAND_INSTALL} ${PRODUCT_DATABASE}"
    echo
    echo 'Minimum machine requirements:'
    echo '- CPUs: 2'
    echo "- Memory: ${OPTION_DEFAULT_VALUES[${OPTION_SWAP_GOAL}]}GB"
    echo '- Storage: 100GB'
    echo
  fi
  return $RETCODE_SUCCESS
}

################################################################################
## @fn echoInfo
##
## @brief Echo an informational message.
##
## @param[in] Message    The message to echo.
## @param[in] Parameter1 An optional parameter for the message that will be
##                       displayed between single-quotes.
## @param[in] Parameter2 A second optional parameter for the message that will
##                       be displayed between parenthesis.
##
## @return RETCODE_SUCCESS
################################################################################
echoInfo() {
  local -r Message="${1:-}"
  local -r Parameter1="${2:-}"
  local -r Parameter2="${3:-}"
  if [[ -n "$Message" ]] ; then
    if [[ -n "$Parameter2" ]] ; then
      if [[ -n "$Parameter1" ]] ; then
        echo "[INFO] ${Message^}:" "'${Parameter1}'" "(${Parameter2})"
      else
        echo "[INFO] ${Message^}" "(${Parameter2})"
      fi
    elif [[ -n "$Parameter1" ]] ; then
      echo "[INFO] ${Message^}:" "'${Parameter1}'"
    else
      echo "[INFO] ${Message^}"
    fi
  fi
  return $RETCODE_SUCCESS
}

################################################################################
## @fn echoOption
##
## @brief Echo the value of a program option or function parameter.
##
## @param[in] Option The option or function parameter. 
## @param[in] Value  The value of the option.
## @param[in] Source The source of value of the option.
## @param[in] Tag    An optional tag to display before the option.
##
## @return RETCODE_SUCCESS
################################################################################
echoOption() {
  local -r Option="${1:-}"
  local -r Value="${2:-}"
  local -r SourceName=$(echoSourceName $3)
  local -r Tag="${4:-}"
  if [[ -n "$Option" ]] ; then
    local -r -i Padding=$(($OPTION_MAXIMUM_LENGTH - ${#Option}))
    if [[ -n "$Tag" ]] ; then
      printf '[%s] ' "$Tag"
    fi
    printf '%s:' "${Option}"
    if [[ -n "$Value" ]] ; then
      if [[ 0 -lt $Padding ]] ; then
        printf ' %.0s' $(seq 1 $Padding)
      fi
      printf ' %s' "$Value"
      if [[ -n "$SourceName" ]] ; then
        printf ' (source: %s)' "$SourceName"
      fi
    fi
    echo
  fi
  return $RETCODE_SUCCESS
}

################################################################################
## @fn echoSection
##
## @brief Echo a title that indicates a section of the program execution.
##
## @param[in] Title The title to display.
##
## @return RETCODE_SUCCESS
################################################################################
echoSection() {
  local -r Section="${1:-}"
  printf '=\n==== %s ====\n=' "${Section^}"
  echo
  return $RETCODE_SUCCESS
}

################################################################################
## @fn echoTitle
##
## @brief Echo a title that indicates a section of the program execution.
##
## @param[in] Title The title to display.
##
## @return RETCODE_SUCCESS
################################################################################
echoTitle() {
  local -r Title="${1:-}"
  local -r -i Length=$((${#Title} + 4))
  printf '=%.0s' $(seq 1 $Length)
  echo
  printf '= %s =' "${Title^}"
  echo
  printf '=%.0s' $(seq 1 $Length)
  echo
  return $RETCODE_SUCCESS
}

################################################################################
## @fn executeCommand
##
## @brief Echo a shell command and its parameters, then execute it.
##
## @param[in] ... The command and its parameters.
##
## @return The exit code of the command.
################################################################################
executeCommand() {
  echoCommand $@
  $@
  return $?
}

################################################################################
## @fn executeCommand2
##
## @brief Echo a shell command and its parameters, and execute it and capture
##        its output into a provided variable.
##
## @param[out] Output The name of a variable in which to store the output of the
##                    of the command.
## @param[in] ...     The command and its parameters.
##
## @return The exit code of the command.
################################################################################
executeCommand2() {
  local DummyOutput=''
  local -n _Output="${1:-DummyOutput}"
  shift
  echoCommand $@
  _Output="$($@)"
  return $?
}

################################################################################
## @fn processCommandCode
##
## @brief Process the exit code of a command and display the message if the exit
##        code denotes an error.
##
## @param[in] ExitCode   The exit code, which will also be displayed with the
##                       message.
## @param[in] Message    A message to display if the exit code denotes an error.
## @param[in] Parameter1 An optional parameter for the message that will be
##                       displayed between single-quotes.
## @param[in] Parameter2 A second optional parameter for the message that will
##                       be displayed between parenthesis.
##
## @return The exit code.
################################################################################
processCommandCode() {
  local -r -i ExitCode=${1:-$RETCODE_INTERNAL_ERROR}
  local -r Message="${2:-}"
  local -r Parameter1="${3:-}"
  local -r Parameter2="${4:-}"
  if [[ $RETCODE_SUCCESS -eq $ExitCode ]] ; then
    echoCommandSuccess
  elif [[ -n "$Parameter2" ]] ; then
    echoError $ExitCode "$Message" "$Parameter1" "${Parameter2}, code=${ExitCode}"
  else
    echoError $ExitCode "$Message" "$Parameter1" "code=${ExitCode}"
  fi
  return $?
}

################################################################################
## @fn setOption
##
## @brief Set the program option to a specified value if it was not already set
##        to a value.
##
## @param[in]     Retcode A return code that causes the function to return
##                        immediately when the code denotes an error.  The
##                        default value of this parameter is RETCODE_SUCCESS.
## @param[out]    Message A message generated when an error has occurred during
##                        the execution of the function.
## @param[in,out] Sources The name of the variable that contains the sources of
##                        the program option values.
## @param[out]    Values  The name of the vatiable that contains the program
##                        option values.
## @param[in]     Source  The source of the specified value.
## @param[in]     Option  The program option to set to the specified value.
## @param[in]     Value   The specified value.
## @param[in]     Suffix  A suffix to append to any error message.
##
## @return The value of the parameter Retcode if it denotes an error, or
##         otherwise the return code of the function execution.
################################################################################
setOption() {
  local DummmyMessage=''
  local -i Retcode=${1:-$RETCODE_SUCCESS}
  local -n _Message="${2:-DummmyMessage}"
  local -n _Sources="$3"
  local -n _Values="$4"
  local -r -i Source=${5:-$OPTION_SOURCE_UNSET}
  local -r DisplayOption="${6:-}"
  local -r Value="${7:-}"
  local -r Suffix="${8:-}"
  if [[ $OPTION_SOURCE_COMMAND -eq $Source ]] ; then
    local -r Option=$(echo "${DisplayOption:${#OPTION_PREFIX}}" | awk '{print tolower($0)}')
  else
    local -r Option=$(echo "$DisplayOption" | awk '{print tolower($0)}')
  fi
  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    if [[ -z "$Option" ]] || [[ -z "${OPTION_SOURCES[${Option}]}" ]] ; then
      if [[ $OPTION_SOURCE_PROGRAM -eq $Source ]] ; then
        _Message=$(echoError $RETCODE_INTERNAL_ERROR 'invalid option' "$DisplayOption" "$Suffix")
      else
        _Message=$(echoError $RETCODE_PARAMETER_ERROR 'invalid option' "$DisplayOption" "$Suffix")
      fi
      Retcode=$?
    elif [[ $OPTION_SOURCE_COMMAND -eq $Source ]] && [[ $((Source & ${OPTION_SOURCES[$Option]})) -ne $Source ]] ; then
      _Message=$(echoError $RETCODE_PARAMETER_ERROR 'option not allowed on command line' "$DisplayOption" "$Suffix")
      Retcode=$?
    elif [[ $OPTION_SOURCE_FILE -eq $Source ]] && [[ $((Source & ${OPTION_SOURCES[$Option]})) -ne $Source ]] ; then
      _Message=$(echoError $RETCODE_PARAMETER_ERROR 'option not allowed in configuration file' "$DisplayOption" "$Suffix")
      Retcode=$?
    elif [[ -z "${_Sources[${Option}]}" ]] ; then
      _Sources["$Option"]=$Source
      _Values["$Option"]="$Value"
    elif [[ $OPTION_SOURCE_UNSET -eq $Source ]] ; then
      unset _Sources["$Option"]
      unset _Values["$Option"]
    elif [[ $OPTION_SOURCE_PROGRAM -ne $Source ]] && [[ $Source -eq ${_Sources[${Option}]} ]] ; then
      _Message=$(echoError $RETCODE_PARAMETER_ERROR 'option already set' "$DisplayOption" "$Suffix")
      Retcode=$?
    fi
  fi
  return $Retcode
}

################################################################################
## @fn processOptionsFile
##
## @brief Read and process the program options in the file indicated by
##        OPTION_FILE_NAME.
##
## @param[in]     Retcode A return code that causes the function to return
##                        immediately when the code denotes an error.  The
##                        default value of this parameter is RETCODE_SUCCESS.
## @param[out]    Message A message when an error has occurred while processing
##                        the program option.
## @param[in,out] Sources The name of the variable that contains the sources of
##                        the program option values.
## @param[in,out] Values  The name of the vatiable that contains the program
##                        option values.
##
## @return The value of the parameter Retcode if it denotes an error, or
##         otherwise the return code of the function execution.
################################################################################
processOptionsFile() {
  local DummmyMessage=''
  local -i Retcode=${1:-$RETCODE_SUCCESS}
  local -r MessageName="${2:-DummmyMessage}"
  local -r SourcesName="$3"
  local -r ValuesName="$4"
  local -n _Message="$MessageName"
  local -n _Sources="$SourcesName"
  local -n _Values="$ValuesName"
  local -r File="${_Values[${OPTION_FILE_NAME}]}"
  local Content=''
  local Option=''
  local Value=''
  local -i Line=1

  if [[ $RETCODE_SUCCESS -ne $Retcode ]] ; then
    return $Retcode
  elif [[ -z "${_Sources[${OPTION_FILE_NAME}]}" ]] ; then # An option file has not been provided.
    return $RETCODE_SUCCESS
  elif [[ -z "$File" ]] ; then
    _Message=$(echoError $RETCODE_PARAMETER_ERROR 'configuration file not provided')
    return $?
  elif ! [[ -f "$File" ]] ; then
    _Message=$(echoError $RETCODE_PARAMETER_ERROR 'unable to find configuration file' "$File")
    return $?
  elif ! [[ -r "$File" ]] ; then
    _Message=$(echoError $RETCODE_PARAMETER_ERROR 'unable to access configuration file' "$File")
    return $?
  fi

  Content=$(sed -e 's/[[:space:]]*\=[[:space:]]*/=/g' \
                -e 's/#.*$//' \
                -e 's/[[:space:]]*$//' \
                -e 's/^[[:space:]]*//' \
                -e "s/^\(.*\)=\([^${CHARACTER_DOUBLE_QUOTE}${CHARACTER_SINGLE_QUOTE}]*\)$/\1=\2/" \
                < "$File")
  if [[ 0 -ne $? ]] ; then
    _Message=$(echoError $RETCODE_OPERATION_ERROR 'error reading configuration file' "$File")
    return $?
  fi

  while IFS='=' read -r Option Value
  do
    if [[ -n "$Option" ]] ; then
      setOption $Retcode "$MessageName" "$SourcesName" "$ValuesName" $OPTION_SOURCE_FILE "$Option" "$Value" "${File}:${Line}"
      Retcode=$?
    elif [[ -n "$Value" ]] ; then
      _Message=$(echoError $RETCODE_PARAMETER_ERROR 'Unexpected value' "$Value" "${File}:${Line}")
      Retcode=$?
    fi
    if [[ $RETCODE_SUCCESS -ne $Retcode ]] ; then
      break
    fi
    Line=$((Line+1))
  done <<< "$Content"

  return $Retcode
}

################################################################################
## @fn retrieveOption
##
## @brief Retrieve the value and, optionally, the description of a program
##        option.
##
## @param[in]  Retcode     A return code that causes the function to return
##                         immediately when the code denotes an error.  The
##                         default value of this parameter is RETCODE_SUCCESS.
## @param[in]  Sources     The name of the variable that contains the sources of
##                         the program option values.
## @param[in]  Values      The name of the vatiable that contains the program
##                         option values.
## @param[in]  Option      The option.
## @param[out] Message     A message when an error has occurred during the
##                         function execution.
## @param[out] Value       The name of the variable in which to store the value
##                         of the program option.  The variable is marked as
##                         read-only when the function succeeds.
## @param[out] Description The optional name of the variable in which to store
##                         the description of the program option.  The variable
##                         is marked as read-only when the function succeeds.
##
## @return The value of the parameter Retcode if it denotes an error, or
##         RETCODE_INTERNAL_ERROR if the value of the parameter is empty, or
##         otherwise RETCODE_SUCCESS.
################################################################################
retrieveOption() {
  local MessageDummy=''
  local ValueDummy=''
  local DescriptionDummy=''
  local -i Retcode=${1:-$RETCODE_SUCCESS}
  local -n _RetrieveSources="$2"
  local -n _RetrieveValues="$3"
  local -r Option="${4:-${OPTION_UNKNOWN}}"
  local -n _RetrieveMessage="${5:-MessageDummy}"
  local -n _Value="${6:-ValueDummy}"
  local -n _Description="${7:-DescriptionDummy}"
  if [[ $RETCODE_SUCCESS -ne $Retcode ]] ; then
    return $Retcode
  elif [[ -z "$Option" ]] || [[ "$OPTION_UNKNOWN" == "$Option" ]] ; then
    _RetrieveMessage=$(echoError $RETCODE_INTERNAL_ERROR 'option not provided')
    Retcode=$?
  else
    local -i Source="${_RetrieveSources[${Option}]}"
    _Value="${_RetrieveValues[${Option}]}"
    _Description="${OPTION_DESCRIPTIONS[${Option}]}"
    if [[ -z "$_Value" ]] ; then
      if [[ -z "${OPTIONS_OPTIONAL[${Option}]}" ]] ; then
        _RetrieveMessage=$(echoError $RETCODE_INTERNAL_ERROR 'value not provided for option' "$Option")
        Retcode=$?
      fi
    else
      if [[ $ECHO_TRACE ]] ; then
        echoOption "$Option" "${_Description^}: $_Value" $Source 'TRACE'
        Retcode=$?
      fi
      readonly _Value
      readonly _Description
    fi
  fi
  return $Retcode
}

################################################################################
## @fn appendLine
##
## @brief Append a line to a text file.
##
## @param[in]  Retcode  A return code that causes the function to return
##                      immediately when the code denotes an error.  The default
##                      value of this parameter is RETCODE_SUCCESS.
## @param[in]  Filename The name of the file to which to append the line.
## @param[in]  Line     The line to append.
##
## @return The value of the parameter Retcode if it denotes an error, or
##         otherwise the return code of the function execution.
################################################################################
appendLine() {
  local -i Retcode=${1:-$RETCODE_SUCCESS}
  local -r Filename="$2"
  local -r Line="$3"
  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    if [[ -z "$Filename" ]] ; then
      echoError $RETCODE_OPERATION_ERROR 'filename was not provided'
      Retcode=$?
    elif [[ -n "$Filename" ]] ; then
      local ReadLine
      local CleanLine
      while read ReadLine; do
        CleanLine=$(echo "$ReadLine" | sed -re 's/^[[:blank:]]+|[[:blank:]]+$//g' -e 's/[[:blank:]]+/ /g')
        if [[ "$Line" == "$CleanLine" ]] ; then
          echoInfo "the line is already present in the file" "$Filename" "$Line"
          return $RETCODE_SUCCESS
        fi
      done < <(sudo 'grep' '-o' '^[^#]*' "$Filename")
      echoCommand 'sudo' 'sh' '-c' "echo -E '${Line}' >> '${Filename}'"
      echo "cat >> '${Filename}' <<EOF
${Line}
EOF" | sudo 'sh'
      processCommandCode $? 'failed to modify file' "$Filename"
      Retcode=$?
    fi
  fi
  return $Retcode
}

################################################################################
## @fn createMarker
##
## @brief Create a file that denotes the successful completion of an
##        installation step.
##
## @param[in] Retcode  A return code that causes the function to return
##                     immediately when the code denotes an error.  The default
##                     value of this parameter is RETCODE_SUCCESS.
## @param[in] User     The user to own the directory.
## @param[in] Group    The group to own the directory.
## @param[in] FileName The name of the installation marker file.
##
## @return The value of the parameter Retcode if it denotes an error, or the
##         return code of the function execution.
################################################################################
createMarker() {
  local -i Retcode=${1:-$RETCODE_SUCCESS}
  local -r User="${2:-root}"
  local -r Group="${3:-root}"
  local -r FileName="${4:-}"
  if [[ $RETCODE_SUCCES -eq $Retcode ]] && [[ -n "$FileName" ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'touch' "$FileName"
    processCommandCode $? "failed to create the installation marker file" "$FileName"
    Retcode=$?
  fi
  return $Retcode
}

################################################################################
## @fn setDirectoryOwnership
##
## @brief Set the ownership of a directory.
##
## @param[in] Retcode              A return code that causes the function to
##                                 return immediately when the code denotes an
##                                 error.  The default value of this parameter
##                                 is RETCODE_SUCCESS.
## @param[in] User                 The user to own the directory.
## @param[in] Group                The group to own the directory.
## @param[in] DirectoryDescription The description of the directory
## @param[in] DirectoryName        The name of the directory.
##
## @return The value of the parameter Retcode if it denotes an error, or the
##         return code of the function execution.
################################################################################
setDirectoryOwnership() {
  local -i Retcode=${1:-$RETCODE_SUCCESS}
  local -r User="${2:-root}"
  local -r Group="${3:-root}"
  local -r DirectoryDescription="${4:-directory}"
  local -r DirectoryName="${5:-}"

echo "CHOWN ${DirectoryName} ${User}:${Group}"

  if [[ $RETCODE_SUCCES -eq $Retcode ]] ; then
    executeCommand 'sudo' 'test' '-d' "$DirectoryName"
    processCommandCode $? "the ${DirectoryDescription} does not exist or is inaccessible" "$DirectoryName"
    Retcode=$?
  fi
  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' 'chown' '-R' "${User}:${Group}" "$DirectoryName"
    processCommandCode $? "failed to set the ownership of the ${DirectoryDescription}" "$DirectoryName" "${User}:${Group}"
    Retcode=$?
  fi
  return $Retcode
}

################################################################################
## @fn deleteDirectory
##
## @brief Delete a directory and all its files and sub-directories, if any.
##
## @param[in] DirectoryDescription The description of the directory.
## @param[in] DirectoryName        The name of the directory to delete.
##
## @return The return code of the function execution.
################################################################################
deleteDirectory() {
  local -r DirectoryDescription="${1:-directory}"
  local -r DirectoryName="${2:-}"
  local -i Retcode=$RETCODE_SUCCESS
  if [[ -n "$DirectoryName" ]] && [[ '/' != "$DirectoryName" ]] ; then
    executeCommand 'sudo' 'test' '-d' "$DirectoryName"
    if [[ 0 -eq $? ]] ; then
      echoCommandSuccess
      executeCommand 'sudo' 'rm' '-rf' "$DirectoryName"
      processCommandCode $? "failed to delete ${DirectoryDescription}" "$DirectoryName"
    else
      echoCommandMessage "the ${DirectoryDescription} does not exist" "$DirectoryName"
    fi
    Retcode=$?
  fi
  return $Retcode
}

################################################################################
## @fn createDirectory
##
## @brief Create a directory.
##
## @param[in] Retcode                    A return code that causes the function
##                                       to return immediately when the code
##                                       denotes an error.  The default value of
##                                       this parameter is RETCODE_SUCCESS.
## @param[in] User                       The user to own the new directory.
## @param[in] Group                      The group to own the new directory.
## @param[in] Permissions                The file permissions of the new
##                                       directory.
## @param[in] DirectoryDescription       The description of the directory
## @param[in] DirectoryName              The name of the directory to create.
## @param[in] ParentDirectoryDescription The description of the parent
##                                       directory.
## @param[in] ParentDirectoryName        The name of an optional parent
##                                       directory of the new directory.  If
##                                       provided, file ownership will be set
##                                       from the parent directory.
## @param[in] bRecreate                  Whether to re-create the directory if
##                                       it already exists.
##
## @return The value of the parameter Retcode if it denotes an error, or the
##         return code of the function execution.
################################################################################
createDirectory() {
  local -i Retcode=${1:-$RETCODE_SUCCESS}
  local -r User="${2:-root}"
  local -r Group="${3:-root}"
  local -r Permissions="${4:-755}"
  local -r DirectoryDescription="${5:-directory}"
  local -r DirectoryName="${6:-}"
  local -r ParentDirectoryDescription="${7:-parent directory}"
  local -r ParentDirectoryName="${8:-}"
  local -r -i bRecreate=${9:-${VALUE_FALSE}}
  local -i bCreate=$VALUE_TRUE
  if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ -z "$DirectoryName" ]] ; then
    echoError $RETCODE_INTERNAL_ERROR "the ${DirectoryDescription} was not provided"
    Retcode=$?
  fi
  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-d' "$DirectoryName"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${DirectoryDescription} already exists" "$DirectoryName"
      executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-r' "$DirectoryName" '-a' '-w' "$DirectoryName"
      processCommandCode $? "the ${DirectoryDescription} is not accessible" "$DirectoryName"
      Retcode=$?
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ $VALUE_TRUE -eq $bRecreate ]] ; then
        echoInfo "the ${DirectoryDescription} will be re-created" "$DirectoryName"
        deleteDirectory "$DirectoryDescription" "$DirectoryName"
        Retcode=$?
        bCreate=$VALUE_TRUE
      fi
    else
      echoCommandMessage "the ${DirectoryDescription} does not exist" "$DirectoryName"
      Retcode=$?
    fi
  fi
  if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ $VALUE_TRUE -eq $bCreate ]] ; then
    executeCommand 'sudo' 'mkdir' '-m' "$Permissions" '-p' "$DirectoryName"
    processCommandCode $? "failed to create the ${DirectoryDescription}" "$DirectoryName"
    Retcode=$?
    if [[ -z "$ParentDirectoryName" ]] ; then
      setDirectoryOwnership $Retcode "$User" "$Group" "$DirectoryDescription" "$DirectoryName"
    else
      setDirectoryOwnership $Retcode "$User" "$Group" "$ParentDirectoryDescription" "$ParentDirectoryName"
    fi
    Retcode=$?
  fi
  return $Retcode
}

################################################################################
## @fn extractFile
##
## @brief Extract a zip file into a specified directory.
##
## @param[in] Retcode              A return code that causes the function to
##                                 return immediately when the code denotes an
##                                 error.  The default value of this parameter
##                                 is RETCODE_SUCCESS.
## @param[in] User                 The user to use to extract.
## @param[in] Group                The group to use to extract.
## @param[in] FileDescription      The description of the zip file to extract.
## @param[in] FileName             The name of the zip file to extract.
## @param[in] DirectoryDescription The description of the directory
## @param[in] DirectoryName        The name of the destination directory.
##
## @return The value of the parameter Retcode if it denotes an error, or the
##         return code of the function execution.
################################################################################
extractFile() {
  local -i Retcode=${1:-$RETCODE_SUCCESS}
  local -r User="${2:-}"
  local -r Group="${3:-}"
  local -r FileDescription="${4:-file}"
  local -r FileName="${5:-}"
  local -r DirectoryDescription="${6:-directory}"
  local -r DirectoryName="${7:-}"

  ### Confirm the source file can be read. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ -n "$FileName" ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$FileName" '-a' '-r' "$FileName"
    processCommandCode $? "the ${FileDescription} does not exist, is inaccessible, or cannot be read" "$FileName" "${User}:${Group}"
    Retcode=$?
  fi

  ### Confirm the destination directory is accessible. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    if [[ -z "$DirectoryName" ]] ; then
      echoError $RETCODE_INTERNAL_ERROR "${DirectoryDescription} was not provided"
    else
      executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-d' "$DirectoryName" '-a' '-r' "$DirectoryName" '-a' '-w' "$DirectoryName"
      processCommandCode $? "the ${DirectoryDescription} does not exist or is inaccessible" "$DirectoryName" "${User}:${Group}"
    fi
    Retcode=$?
  fi

  ### Extract the source file into the destination directory. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ -n "$FileName" ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'unzip' '-o' '-d' "$DirectoryName" "$FileName"
    processCommandCode $? "failed to unzip the ${FileDescription}" "$FileName" "$DirectoryName"
    Retcode=$?
  fi

  return $Retcode
}

################################################################################
## @fn extractPatch
##
## @brief Extract an Oracle patch package zip file.
##
## @param[out] PatchHome            The directory of the extracted patch.  If
##                                  the patch has already been applied, the
##                                  value of this variable will be empty.
## @param[out] PatchNumber          The patch number.
## @param[out] PatchMarker          The name of a file that denotes whether the
##                                  patch has been applied.  This function
##                                  validates the presence of this file but it
##                                  does not create it.
## @param[in]  User                 The installation user.
## @param[in]  Group                The installation group.
## @param[in]  Permissions          The file permissions for the patch home
##                                  directory.
## @param[in]  Description          The description of the patch.
## @param[in]  FileDescription      The description of the package zip
##                                  file that contains the patch.
## @param[in]  FileName             The name of the package zip file that
##                                  contains the patch.
## @param[in]  FileNameDescription  The description of the name of the
##                                  package zip file.
## @param[in]  DirectoryDescription The description of the directory in which
##                                  the package zip file will be extracted.
## @param[in]  DirectoryName        The name of the directory in which the
##                                  package zip file will be extracted.
## @param[in]  MarkerBase           The root portion of the file name of the
##                                  installation marker.
##
## @note All product file and directory names should be in the absolute form.
##
## @note This function performs the following steps:
##
## @li Validate that the patch requires to be extracted.
## @li Create the patch base directory, if it does not already exist.
## @li Extract the patch package zip file in the patch base directory.
##
## @return The return code of the function execution.
################################################################################
extractPatch() {
  local PatchHomeDummy=''
  local PatchNumberDummy=''
  local PatchMarkerDummy=''
  local -n _PatchHome="${1:-PatchHomeDummy}"
  local -n _PatchNumber="${2:-PatchNumberDummy}"
  local -n _PatchMarker="${3:-PatchMarkerDummy}"
  local -r User="${4:-}"
  local -r Group="${5:-}"
  local -r Permissions="${6:-755}"
  local -r Description="${7:-patch}"
  local -r FileDescription="${8:-patch file}"
  local -r FileName="${9:-}"
  local -r FileNameDescription="${10:-name of the patch file}"
  local -r DirectoryDescription="${11:-extraction directory}"
  local -r DirectoryName="${12:-}"
  local -r MarkerBase="${13:-}"
  local -i Retcode=$RETCODE_SUCCESS

  _PatchHome=''
  _PatchNumber=''
  _PatchMarker=''

  if [[ -n "$FileName" ]] && [[ -n "$DirectoryName" ]] ; then
    local -i bProceed=$VALUE_TRUE

    _PatchNumber=$(basename "${FileName}" | sed -r 's/p([0-9]*)_.*/\1/g')

    echoSection "extraction of the ${Description} '${_PatchNumber}'"

    ### Verify whether the patch package file is valid and can be read. ###

    if [[ -z "$_PatchNumber" ]] ; then
      echoError $RETCODE_PARAMETER_ERROR "unable to determine a patch number from the ${FileNameDescription}" "$FileName"
    else
      executeCommand 'sudo' 'test' '-f' "$FileName" '-a' '-r' "$FileName"
      processCommandCode $? "the ${FileDescription} does not exist, is inaccessible, or cannot be read" "$FileName"
    fi
    Retcode=$?

    ### Verify whether the patch has already been applied. ###

    if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ -n "$MarkerBase" ]] ; then
      _PatchMarker="${MarkerBase}_${_PatchNumber}"
      executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$_PatchMarker"
      if [[ 0 -eq $? ]] ; then
        bProceed=$VALUE_FALSE
        echoCommandMessage "the ${Description} '${_PatchNumber}' is already applied" "$FileName"
      else
        echoCommandMessage "the ${Description} '${_PatchNumber}' has not been applied" "$FileName"
      fi
      Retcode=$?
    fi

    ### Create the patch base directory. ###

    if [[ $VALUE_TRUE -eq $bProceed ]] ; then
      createDirectory $Retcode "$User" "$Group" "$Permissions" "$DirectoryDescription" "$DirectoryName"
      Retcode=$?
    fi

    ### Extract the patch package file to the patch base directory. ###

    if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ $VALUE_TRUE -eq $bProceed ]] ; then
      local -r PatchHomeDescription="home directory for ${Description} '${_PatchNumber}'"
      _PatchHome="${DirectoryName}/${_PatchNumber}"
      executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "${_PatchHome}/README.txt" '-o' '-f' "${_PatchHome}/README.html"
      if [[ 0 -eq $? ]] ; then
        echoCommandMessage "the ${FileDescription} is already unzipped" "$FileName" "$_PatchHome"
        Retcode=$?
      else
        echoCommandMessage "the ${FileDescription} has not been unzipped" "$FileName" "$_PatchHome"
        extractFile $? "$User" "$Group" "$FileDescription" "$FileName" "$DirectoryDescription" "$DirectoryName"
        setDirectoryOwnership $? "$User" "$Group" "$PatchHomeDescription" "$_PatchHome"
        Retcode=$?
        if [[ $RETCODE_SUCCESS -ne $Retcode ]] ; then
          deleteDirectory "$PatchHomeDescription" "$_PatchHome"
        fi
      fi
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-d' "$_PatchHome" '-a' '-r' "$_PatchHome"
        processCommandCode $? "the ${PatchHomeDescription} does not exist, is inaccessible, or cannot be read" "$_PatchHome"
        Retcode=$?
      else
        _PatchHome=''
      fi
    fi
  fi

  return $Retcode
}

################################################################################
## @fn updatePatcher
##
## @brief Update the Oracle product patching utility.
##
## @param[in] Retcode         A return code that causes the function to return
##                            immediately when the code denotes an error.
##                            The default value of this parameter is
##                            RETCODE_SUCCESS.
## @param[in] User            The installation user.
## @param[in] Group           The installation group.
## @param[in] Description     The description of the patching utility.
## @param[in] FileDescription The description of the package zip file that
##                            contains the updated patching utility.
## @param[in] FileName        The name of the package zip file that
##                            contains the updated patching utility.
## @param[in] HomeName        The installation directory of the patching
##                            utility.
## @param[in] HomeDescription The description of the installation (home)
##                            directory of the patching utility.
## @param[in] Marker          The name of a file which presence denotes that the
##                            patching utility has been updated.  This function
##                            creates the file upon successful completion of the
##                            update.
##
## @note All product file and directory names should be in the absolute form.
##
## @note This function performs the following steps:
##
## @li Validate that the patching utility requires updating.
## @li Rename the original patching utility home directory for backup.
## @li Extract the update package file to the paching utility home directory.
## @li Create a marker file to denote that the patching utility has been
##     updated.
##
## @return The value of the parameter Retcode if it denotes an error, or the
##         return code of the function execution.
################################################################################
updatePatcher() {
  local -i Retcode=${1:-$RETCODE_SUCCESS}
  local -r User="${2:-}"
  local -r Group="${3:-}"
  local -r Description="${4:-patcher}"
  local -r FileDescription="${5:-patch update file}"
  local -r FileName="${6:-}"
  local -r HomeDescription="${7:-home directory of the patcher}"
  local -r HomeName="${8:-}"
  local -r Marker="${9:-}"

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ -n "$FileName" ]] ; then
    local -r HomeBackup="${HomeName}-backup"
    local -r BaseName="$(dirname ${HomeName})"
    local -r BaseDescription="base directory of the ${Description}"
    local -i bProceed=$VALUE_TRUE
    local -i bMoved=$VALUE_FALSE

    echoSection "update of the ${Description}"

    ### Verify whether the package update file has already been updated. ###

    if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ -n "$Marker" ]] ; then
      executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$Marker"
      if [[ 0 -eq $? ]] ; then
        bProceed=$VALUE_FALSE
        echoCommandMessage "the ${FileDescription} is already updated" "$FileName" "$HomeName"
      else
        echoCommandMessage "the ${FileDescription} has not been updated" "$FileName" "$HomeName"
      fi
      Retcode=$?
    fi

    ### Rename the original patching utility home to serve as backup. ###

    if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ $VALUE_TRUE -eq $bProceed ]] ; then
      executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'mv' "$HomeName" "$HomeBackup"
      processCommandCode $? "failed to move the ${HomeDescription}" "$HomeName" "$HomeBackup"
      Retcode=$?
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        bMoved=$VALUE_TRUE
      fi
    fi

    ### Extract the package update file to the patching utility home directory. ###

    if [[ $VALUE_TRUE -eq $bProceed ]] ; then
      extractFile $Retcode "$User" "$Group" "$FileDescription" "$FileName" "$BaseDescription" "$BaseName"
      createMarker $? "$User" "$Group" "$Marker"
      Retcode=$?
    fi

    ### Restore the original patcher if an error occurred. ###

    if [[ $RETCODE_SUCCESS -ne $Retcode ]] && [[ $VALUE_TRUE -eq $bMoved ]] ; then
      deleteDirectory "$HomeDescription" "$HomeName"
      if [[ $RETCODE_SUCCESS -eq $? ]] ; then
        executeCommand 'sudo' 'mv' "$HomeBackup" "$HomeName"
        processCommandCode $? "failed to restore the ${HomeDescription}" "$HomeBackup" "$HomeName"
      fi
    fi
  fi

  return $Retcode
}

################################ Main program functions ################################

################################################################################
## @fn displayOptions
##
## @brief Display the program options.
##
## @param[in] Sources The name of the variable that contains the sources of the
##                    program option values.
## @param[in] Values  The name of the vatiable that contains the program option
##                    values.
##
## @return RETCODE_SUCCESS
################################################################################
displayOptions() {
  local -n _Sources="$1"
  local -n _Values="$2"
  local Option
  echoTitle 'Program options'
  for Option in "${OPTIONS[@]}" ; do
    echoOption "$Option" "${_Values[${Option}]}" "${_Sources[${Option}]}" 'OPTION'
  done
  return $RETCODE_SUCCESS
}

################################################################################
## @fn installDatabase
##
## @brief Install and launch the Oracle Database (Listener + Starter database).
##
## @param[in] Sources The name of the variable that contains the sources of the
##                    program option values.
## @param[in] Values  The name of the vatiable that contains the program option
##                    values.
##
## @note This function performs the following steps:
##
## @li Generation of a response file for the automated installation of the
##     Oracle Database.
## @li Extraction of the Oracle Database software to the Oracle Home directory.
## @li Extraction of the Oracle OPatch utility update, if provided, to the
##     sub-directory OPatch in the Oracle Home directory.
## @li Installation of the Oracle Database by running the Oracle installer
##     program runInstaller and apply a databae update patch upon installation,
##     if provided.
## @li Execution of the Oracle post-installation scripts orainstRoot.sh and
##     root.sh.
## @li Configuration of the networking information by executing the Oracle
##     installer program runInstaller with the option -executeConfigTools.
## @li Deletion of the automated installation response file.
## @li Modification of the file /etc/oratab to enable the automatic starting
##     and stopping the database with Systemd.
## @li Configuration of the settings of the Oracle Database that are necessary
##     for supporting Oracle Enterprise Manager.
##
## @return The return code of the function execution.
################################################################################
installDatabase() {
  local Message=''
  local StageDirectory=''
  local InventoryDirectory=''
  local FilePermissions=''
  local User=''
  local Group=''
  local PackageFileName=''
  local OPatchFileName=''
  local UpgradePatchFileName=''
  local UpgradePatchFileNameDescription=''
  local ResponseFileName=''
  local ResponseFilePermissions=''
  local ResponseFilePermissionsDescription=''
  local BaseDirectory=''
  local HomeDirectory=''
  local HomeDirectoryDescription=''
  local DBAGroup=''
  local DataDirectory=''
  local RecoveryDirectory=''
  local DatabaseName=''
  local Password=''
  local SystemdService=''
  local SystemdServiceDescription=''
  echoTitle "Installing the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]}"
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_STAGE"                 'Message' 'StageDirectory'
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_INVENTORY"             'Message' 'InventoryDirectory'
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_FILE_PERMISSIONS"      'Message' 'FilePermissions'
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_USER"                  'Message' 'User'
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_GROUP"                 'Message' 'Group'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_PACKAGE_FILE_NAME"         'Message' 'PackageFileName'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_OPATCH_FILE_NAME"          'Message' 'OPatchFileName'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_UPGRADE_PATCH_FILE_NAME"   'Message' 'UpgradePatchFileName' 'UpgradePatchFileNameDescription'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_RESPONSE_FILE_NAME"        'Message' 'ResponseFileName'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_RESPONSE_FILE_PERMISSIONS" 'Message' 'ResponseFilePermissions' 'ResponseFilePermissionsDescription'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_BASE"                      'Message' 'BaseDirectory'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_HOME"                      'Message' 'HomeDirectory' 'HomeDirectoryDescription'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_ADMINISTRATOR_GROUP"       'Message' 'DBAGroup'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_DATA"                      'Message' 'DataDirectory'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_RECOVERY"                  'Message' 'RecoveryDirectory'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_NAME"                      'Message' 'DatabaseName'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_PASSWORD"                  'Message' 'Password'
  retrieveOption $? "$1" "$2" "$OPTION_SYSTEMD_SERVICE"                    'Message' 'SystemdService' 'SystemdServiceDescription'
  local -i Retcode=$?
  local -r InventoryInstaller="${InventoryDirectory}/orainstRoot.sh"
  local -r InventoryInstallerDescription='Oracle Inventory root installer program'
  local -r DatabaseInstaller="${HomeDirectory}/runInstaller"
  local -r DatabaseInstallerDescription="${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} installer program"
  local -r DatabaseRootInstaller="${HomeDirectory}/root.sh"
  local -r DatabaseRootInstallerDescription="${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} root installer program"
  local -r MarkerDatabaseExtracted="${HomeDirectory}/INSTALLATION_STEP_DATABASE_EXTRACTED"
  local -r MarkerOPatchUpdated="${HomeDirectory}/INSTALLATION_STEP_OPATCH_UPDATED"
  local -r MarkerPatchApplied="${HomeDirectory}/PATCH_APPLIED"
  local -r MarkerDatabaseInstalled="${HomeDirectory}/INSTALLATION_STEP_DATABASE_INSTALLED"
  local -r MarkerInventoryConfigured="${HomeDirectory}/INSTALLATION_STEP_INVENTORY_CONFIGURED"
  local -r MarkerRootConfigured="${HomeDirectory}/INSTALLATION_STEP_ROOT_CONFIGURED"
  local -r MarkerDatabaseConfigured="${HomeDirectory}/INSTALLATION_STEP_DATABASE_CONFIGURED"
  local -r MarkerOratabModified="${HomeDirectory}/INSTALLATION_STEP_ORATAB_MODIFIED"
  local -r MarkerDatabasePrepared="${HomeDirectory}/INSTALLATION_STEP_DATABASE_PREPARED"
  local -i bResponseCreated=$VALUE_FALSE

  if [[ $RETCODE_SUCCESS -ne $Retcode ]] ; then
    echo "$Message"
    return $Retcode
  fi

  ###########################################################################
  # Generation of the Oracle Database automated installation response file. #
  ###########################################################################

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoSection "Generation of the ${DESCRIPTION_DATABASE_RESPONSE_FILE}"
  fi

  ### Generate the response file. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$MarkerDatabaseInstalled" '-a' '-f' "$MarkerDatabaseConfigured"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} is already installed and configured"
    else
      echoCommandMessage "the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} has not been installed or configured"
      echoInfo "a ${DESCRIPTION_DATABASE_RESPONSE_FILE} will be generated" "$ResponseFileName"
      executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-r' "$ResponseFileName"
      if [[ 0 -eq $? ]] ; then
        echoCommandMessage "the ${DESCRIPTION_DATABASE_RESPONSE_FILE} already exists and will be overwritten" "$ResponseFileName"
      else
        echoCommandMessage "the ${DESCRIPTION_DATABASE_RESPONSE_FILE} does not exist" "$ResponseFileName"
      fi
      echoCommand 'sudo' '-u' "$User" '-g' "$Group" "cat > '${ResponseFileName}' <<EOF ... EOF"
      echo "cat > ${ResponseFileName} <<EOF
oracle.install.responseFileVersion=/oracle/install/rspfmt_dbinstall_response_schema_v19.0.0
oracle.install.option=INSTALL_DB_AND_CONFIG
UNIX_GROUP_NAME=${Group}
INVENTORY_LOCATION=${InventoryDirectory}
ORACLE_HOME=${HomeDirectory}
ORACLE_BASE=${BaseDirectory}
oracle.install.db.InstallEdition=EE
oracle.install.db.OSDBA_GROUP=${DBAGroup}
oracle.install.db.OSBACKUPDBA_GROUP=${DBAGroup}
oracle.install.db.OSDGDBA_GROUP=${DBAGroup}
oracle.install.db.OSKMDBA_GROUP=${DBAGroup}
oracle.install.db.OSRACDBA_GROUP=${DBAGroup}
oracle.install.db.rootconfig.executeRootScript=false
oracle.install.db.rootconfig.configMethod=SUDO
oracle.install.db.rootconfig.sudoPath=`which sudo`
oracle.install.db.rootconfig.sudoUserName=${User}
oracle.install.db.config.starterdb.type=GENERAL_PURPOSE
oracle.install.db.config.starterdb.globalDBName=${DatabaseName}
oracle.install.db.config.starterdb.SID=${DatabaseName}
oracle.install.db.config.starterdb.characterSet=AL32UTF8
oracle.install.db.config.starterdb.memoryOption=false
oracle.install.db.config.starterdb.memoryLimit=2048
oracle.install.db.config.starterdb.installExampleSchemas=false
oracle.install.db.config.starterdb.password.ALL=${Password}
oracle.install.db.config.starterdb.managementOption=DEFAULT
oracle.install.db.config.starterdb.enableRecovery=true
oracle.install.db.config.starterdb.storageType=FILE_SYSTEM_STORAGE
oracle.install.db.config.starterdb.fileSystemStorage.dataLocation=${DataDirectory}
oracle.install.db.config.starterdb.fileSystemStorage.recoveryLocation=${RecoveryDirectory}
EOF" | sudo '-u' "$User" '-g' "$Group" 'sh'
      processCommandCode $? "the ${DESCRIPTION_DATABASE_RESPONSE_FILE} was not created" "$ResponseFileName"
      Retcode=$?
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        bResponseCreated=$VALUE_TRUE
      fi
      ### Restrict the file permissions of the response file. ###
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'sudo' 'chmod' ${ResponseFilePermissions} "$ResponseFileName"
        processCommandCode $? "failed to restrict the ${ResponseFilePermissionsDescription} to '${ResponseFilePermissions}'" "$ResponseFileName"
        Retcode=$?
      fi
      ### Validate that the response file is accessible by the installation user. ###
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-r' "$ResponseFileName"
        processCommandCode $? "the ${DESCRIPTION_DATABASE_RESPONSE_FILE} does not exist or is inaccessible" "$ResponseFileName"
        Retcode=$?
      fi
    fi
  fi

  ######################################
  # Copy the Oracle Database software. #
  ######################################

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoSection "Extraction of the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} software"
  fi

  ### Validate that the Oracle Database home directory can be written. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-d' "$HomeDirectory" '-a' '-w' "$HomeDirectory"
    processCommandCode $? "the ${HomeDirectoryDescription} does not exist, is inaccessible, or is not writable" "$HomeDirectory"
    Retcode=$?
  fi

  ### Unzip the Oracle Database software package to the Oracle Database home directory. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$MarkerDatabaseInstalled"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} is already installed" "$HomeDirectory"
      echoInfo "Skipping extraction the ${DESCRIPTION_DATABASE_PACKAGE_FILE}" "$HomeDirectory"
      Retcode=$?
    else
      echoCommandMessage "the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} has not been installed" "$HomeDirectory"
      executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$MarkerDatabaseExtracted"
      if [[ 0 -eq $? ]] ; then
        echoCommandMessage "the ${DESCRIPTION_DATABASE_PACKAGE_FILE} is already unzipped" "$PackageFileName" "$HomeDirectory"
        Retcode=$?
      else
        echoCommandMessage "the ${DESCRIPTION_DATABASE_PACKAGE_FILE} has not been unzipped" "$PackageFileName" "$HomeDirectory"
        executeCommand 'sudo' 'test' '-f' "$PackageFileName" '-a' '-r' "$PackageFileName"
        processCommandCode $? "the ${DESCRIPTION_DATABASE_PACKAGE_FILE} does not exist, is inaccessible, or cannot be read" "$PackageFileName"
        Retcode=$?
        if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
          executeCommand 'sudo' 'unzip' '-d' "$HomeDirectory" "$PackageFileName"
          processCommandCode $? "failed to unzip the ${DESCRIPTION_DATABASE_PACKAGE_FILE}" "$PackageFileName" "${HomeDirectory}"
          setDirectoryOwnership $? "$User" "$Group" "$HomeDirectoryDescription" "$HomeDirectory"
          createMarker $? "$User" "$Group" "$MarkerDatabaseExtracted"
          Retcode=$?
        fi
      fi
    fi
  fi

  updatePatcher \
    $Retcode \
    "$User" \
    "$Group" \
    "$DESCRIPTION_DATABASE_OPATCH" \
    "$DESCRIPTION_DATABASE_OPATCH_FILE" \
    "$OPatchFileName" \
    "$DESCRIPTION_DATABASE_OPATCH_HOME" \
    "${HomeDirectory}/OPatch" \
    "$MarkerOPatchUpdated"
  Retcode=$?

  local PatchHome=''
  local PatchMarker=''

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    extractPatch \
      'PatchHome' \
      '' \
      'PatchMarker' \
      "$User" \
      "$Group" \
      "$FilePermissions" \
      "$DESCRIPTION_DATABASE_UPGRADE_PATCH" \
      "$DESCRIPTION_DATABASE_UPGRADE_PATCH_FILE" \
      "$UpgradePatchFileName" \
      "$UpgradePatchFileNameDescription" \
      "${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} patch staging directory" \
      "${StageDirectory}/${PRODUCT_DATABASE}-patches" \
      "$MarkerPatchApplied"
    Retcode=$?
  fi

  ########################################
  # Installation of the Oracle Database. #
  ########################################

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoSection "Installation of the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]}"
  fi

  ### Change the current working directory to the Oracle Database home directory. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    if [[ ! -d "$HomeDirectory" ]] || [[ ! -x "$HomeDirectory" ]] ; then
      echoError $RETCODE_OPERATION_ERROR "the ${HomeDirectoryDescription} does not exist or is inaccessible" "$HomeDirectory"
    else
      echoCommand 'cd' "$HomeDirectory"
      cd "$HomeDirectory"
      processCommandCode $? "failed to change the current working directory to the ${HomeDirectoryDescription}" "$HomeDirectory"
    fi
    Retcode=$?
  fi

  ### Export the ORACLE_HOME environment variable. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoCommand 'export' "ORACLE_HOME=${HomeDirectory}"
    export ORACLE_HOME="$HomeDirectory"
    processCommandCode $? "failed to export the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} environment variable ORACLE_HOME" "$HomeDirectory"
    Retcode=$?
  fi

  ### Export the LD_LIBRARY_PATH environment variable. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoCommand 'export' "LD_LIBRARY_PATH=${HomeDirectory}/lib:${LD_LIBRARY_PATH}"
    export LD_LIBRARY_PATH="${HomeDirectory}/lib:${LD_LIBRARY_PATH}"
    processCommandCode $? "failed to export the environment variable LD_LIBRARY_PATH" "$LD_LIBRARY_PATH"
    Retcode=$?
  fi

  ### Export the CV_ASSUME_DISTID environment variable to enable installing on Oracle Linux 8 and 9. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    local -r CV_ASSUME_DISTID_VALUE='OEL8'
    echoCommand 'export' "CV_ASSUME_DISTID=${CV_ASSUME_DISTID_VALUE}"
    export CV_ASSUME_DISTID="$CV_ASSUME_DISTID_VALUE"
    processCommandCode $? "failed to export the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} environment variable CV_ASSUME_DISTID" "$CV_ASSUME_DISTID_VALUE"
    Retcode=$?
  fi

  ### Install the Oracle Database. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$MarkerDatabaseInstalled"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} is already installed" "$HomeDirectory"
    else
      echoCommandMessage "the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} has not been installed" "$HomeDirectory"
      echoInfo "installing the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} with a ${DESCRIPTION_DATABASE_RESPONSE_FILE}" "$ResponseFileName"
      if [[ -n "$PatchHome" ]] ; then
        executeCommand 'sudo' '-E' '-u' "$User" '-g' "$Group" "${DatabaseInstaller}" '-silent' '-responseFile' "$ResponseFileName" '-applyRU' "$PatchHome"
      else
        executeCommand 'sudo' '-E' '-u' "$User" '-g' "$Group" "${DatabaseInstaller}" '-silent' '-responseFile' "$ResponseFileName"
      fi
      processCommandCode $? "an error occurred when running the ${DatabaseInstallerDescription}" "$DatabaseInstaller"
      createMarker $? "$User" "$Group" "$PatchMarker"
      createMarker $? "$User" "$Group" "$MarkerDatabaseInstalled"
    fi
    Retcode=$?
  fi

  #######################################
  # Perform the post-installation steps #
  #######################################

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoSection "Post-installation steps"
  fi

  ### Run the Oracle inventory root installer program, if it exists, using the installation user. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$MarkerInventoryConfigured"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${InventoryInstallerDescription} has already been run" "$InventoryInstaller"
    else
      echoCommandMessage "the ${InventoryInstallerDescription} has not been run" "$InventoryInstaller"
      executeCommand 'sudo' '-E' '-u' "$User" '-g' "$Group" 'sudo' 'test' '-f' "$InventoryInstaller" '-a' '-x' "$InventoryInstaller"
      if [[ 0 -eq $? ]] ; then
        echoCommandSuccess
        executeCommand 'sudo' '-E' '-u' "$User" '-g' "$Group" 'sudo' "$InventoryInstaller"
        processCommandCode $? "an error occurred when running the ${InventoryInstallerDescription}" "$InventoryInstaller"
        createMarker $? "$User" "$Group" "$MarkerInventoryConfigured"
      else
        echoCommandMessage "the ${InventoryInstallerDescription} does not exist, is inaccessible, or cannot be executed" "$InventoryInstaller"
        echoInfo "skipping running the ${InventoryInstallerDescription}" "$InventoryInstaller"
      fi
    fi
    Retcode=$?
  fi

  ### Run the Oracle Database root installer program using the installation user. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$MarkerRootConfigured"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${DatabaseRootInstallerDescription} has already been run" "$DatabaseRootInstaller"
      Retcode=$?
    else
      echoCommandMessage "the ${DatabaseRootInstallerDescription} has not been run" "$DatabaseRootInstaller"
      executeCommand 'sudo' '-E' '-u' "$User" '-g' "$Group" 'sudo' 'test' '-f' "$DatabaseRootInstaller" '-a' '-x' "$DatabaseRootInstaller"
      processCommandCode $? "the ${DatabaseRootInstallerDescription} does not exist, is inaccessible, or cannot be executed" "$DatabaseRootInstaller"
      Retcode=$?
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'sudo' '-E' '-u' "$User" '-g' "$Group" 'sudo' '-E' "$DatabaseRootInstaller"
        processCommandCode $? "an error occurred when running the ${DatabaseRootInstallerDescription}" "$DatabaseRootInstaller"
        createMarker $? "$User" "$Group" "$MarkerRootConfigured"
        Retcode=$?
      fi
    fi
  fi

  ### Configure the Oracle Database network settings using the installation user. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$MarkerDatabaseConfigured"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the network information of the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} is already configured"
    else
      echoCommandMessage "the network information of the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} has not been configured"
      executeCommand 'sudo' '-E' '-u' "$User" "$DatabaseInstaller" '-executeConfigTools' '-silent' '-responseFile' "$ResponseFileName"
      processCommandCode $? "an error occurred when running the ${DatabaseInstallerDescription}" "${DatabaseInstaller} -executeConfigTools"
      createMarker $? "$User" "$Group" "$MarkerDatabaseConfigured"
    fi
    Retcode=$?
  fi

  ### Delete the Oracle Database automated installation response file. ###

  if [[ $VALUE_TRUE -eq $bResponseCreated ]] ; then
    executeCommand sudo '-u' "$User" '-g' "$Group" 'test' '-f' "$ResponseFileName"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${DESCRIPTION_DATABASE_RESPONSE_FILE} will be deleted" "$ResponseFileName"
      executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'rm' "$ResponseFileName"
      processCommandCode $? "failed to the delete the ${DESCRIPTION_DATABASE_RESPONSE_FILE}" "$ResponseFileName"
    else
      echoCommandMessage "the ${DESCRIPTION_DATABASE_RESPONSE_FILE} does not exist" "$ResponseFileName"
    fi
  fi

  ### Modify the oratab file to enable the automatic start and shutdown of the database with dbstart and dbshut. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$MarkerOratabModified"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the automatic start of the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} is already enabled"
    else
      echoCommandMessage "the automatic start of the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} has not been enabled"
      executeCommand 'sudo' 'test' '-f' "$ORATAB_FILE_NAME"
      if [[ 0 -eq $? ]] ; then
        echoCommandMessage "file exists" "$ORATAB_FILE_NAME"
        executeCommand 'sudo' 'sed' '-i' 's/:N$/:Y/' "$ORATAB_FILE_NAME"
        processCommandCode $? 'failed to modify the file' "$ORATAB_FILE_NAME"
        createMarker $? "$User" "$Group" "$MarkerOratabModified"
      else
        echoCommandMessage "file does not exist" "$ORATAB_FILE_NAME"
      fi
    fi
    Retcode=$?
  fi

  #########################################
  # Configuration of the Oracle Database. #
  #########################################

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoSection "Configuration of the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]}"
  fi

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$MarkerDatabasePrepared"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} is already configured" "$DatabaseName"
      Retcode=$?
    else
      echoCommandMessage "the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} has not been configured" "$DatabaseName"

      ### Change the current working directory to the Oracle Database home directory. ###

      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        echoCommand 'cd' "$HomeDirectory"
        cd "$HomeDirectory"
        processCommandCode $? "failed to change the current working directory to the ${HomeDirectoryDescription}" "$HomeDirectory"
        Retcode=$?
      fi

      ### Export the ORACLE_HOME environment variable. ###

      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        echoCommand 'export' "ORACLE_HOME=${HomeDirectory}"
        export ORACLE_HOME="$HomeDirectory"
        processCommandCode $? "failed to export the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} environment variable ORACLE_HOME" "$HomeDirectory"
        Retcode=$?
      fi

      ### Configure the Oracle Database parameters required by Oracle Enterprise Manager. ###

      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'sudo' '-E' '-u' "$User" '-g' "$Group" "${HomeDirectory}/bin/sqlplus" '/nolog' <<EOF
CONNECT sys/${Password}@${DatabaseName} AS sysdba
ALTER SYSTEM SET "_allow_insert_with_update_check"=true scope=both;
ALTER SYSTEM SET session_cached_cursors=200 scope=spfile;
ALTER SYSTEM SET shared_pool_size=600M scope=spfile;
ALTER SYSTEM SET processes=600 scope=spfile;
SHUTDOWN TRANSACTIONAL
EOF
        processCommandCode $? "failed to configure the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} parameters" "$DatabaseName"
        Retcode=$?
      fi

      ### Restart the Oracle Database. ###

      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'sudo' 'systemctl' 'restart' "$SystemdService"
        processCommandCode $? "failed to restart the ${SystemdServiceDescription}" "$SystemdService"
        Retcode=$?
      fi

      ### Create indicator that the Oracle Database has been configured. ###

      createMarker $Retcode "$User" "$Group" "$MarkerDatabasePrepared"
      Retcode=$?
    fi
  fi

  return $Retcode
}

###############################################################################
## @fn installManager
##
## @brief Install and launch the Oracle Enterprise Manager.
##
## @param[in] Sources The name of the variable that contains the sources of the
##                    program option values.
## @param[in] Values  The name of the vatiable that contains the program option
##                    values.
##
## @note This function performs the following steps:
##
## @li Generation of a response file for the automated installation of the
##     Oracle Enterprise Manager.
## @li Installation of the Oracle Enterprise Manager.
## @li Deletion of the automated installation response file.
## @li Execution of the allroot.sh script.
## @li Configuration of Firewalld to allow external network access to Oracle
##     Enterprise Manager.
##
## @return The return code of the function execution.
################################################################################
installManager() {
  local Message=''
  local StageDirectory=''
  local StageDirectoryDescription=''
  local InventoryDirectory=''
  local User=''
  local Group=''
  local Hostname=''
  local DatabaseData=''
  local DatabaseName=''
  local DatabasePort=''
  local DatabasePassword=''
  local Version=''
  local PackagesFileNames=''
  local PackagesFileNamesDescription=''
  local OPatchFileName=''
  local OMSPatcherFileName=''
  local UpgradePatchFileName=''
  local UpgradePatchFileNameDescription=''
  local PatchesFileNames=''
  local PatchesFileNamesDescription=''
  local ResponseFileName=''
  local ResponseFilePermissions=''
  local ResponseFilePermissionsDescription=''
  local BaseDirectory=''
  local HomeDirectory=''
  local InstanceDirectory=''
  local ManagerPort=''
  local ManagerPortDescription=''
  local ManagerPassword=''
  local ManagerKeystoreFileName=''
  local ManagerKeystorePassword=''
  local ManagerTruststoreFileName=''
  local ManagerTruststorePassword=''
  local AgentBase=''
  local AgentPassword=''
  local WeblogicPort=''
  local WeblogicPortDescription=''
  local WeblogicPassword=''
  local SystemdService=''
  echoTitle "Installing the ${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]}"
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_STAGE"                'Message' 'StageDirectory' 'StageDirectoryDescription'
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_INVENTORY"            'Message' 'InventoryDirectory'
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_USER"                 'Message' 'User'
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_GROUP"                'Message' 'Group'
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_HOSTNAME"             'Message' 'Hostname'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_DATA"                     'Message' 'DatabaseData'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_NAME"                     'Message' 'DatabaseName'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_PORT"                     'Message' 'DatabasePort'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_PASSWORD"                 'Message' 'DatabasePassword'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_VERSION"                   'Message' 'Version'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_PACKAGES_FILE_NAMES"       'Message' 'PackagesFileNames' 'PackagesFileNamesDescription'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_OPATCH_FILE_NAME"          'Message' 'OPatchFileName'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_OMSPATCHER_FILE_NAME"      'Message' 'OMSPatcherFileName'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_UPGRADE_PATCH_FILE_NAME"   'Message' 'UpgradePatchFileName' 'UpgradePatchFileNameDescription'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_PATCHES_FILE_NAMES"        'Message' 'PatchesFileNames' 'PatchesFileNamesDescription'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_RESPONSE_FILE_NAME"        'Message' 'ResponseFileName'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_RESPONSE_FILE_PERMISSIONS" 'Message' 'ResponseFilePermissions' 'ResponseFilePermissionsDescription'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_BASE"                      'Message' 'BaseDirectory'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_HOME"                      'Message' 'HomeDirectory'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_INSTANCE"                  'Message' 'InstanceDirectory'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_PORT"                      'Message' 'ManagerPort' 'ManagerPortDescription'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_PASSWORD"                  'Message' 'ManagerPassword'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_KEYSTORE_FILE_NAME"        'Message' 'ManagerKeystoreFileName'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_KEYSTORE_PASSWORD"         'Message' 'ManagerKeystorePassword'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_TRUSTSTORE_FILE_NAME"      'Message' 'ManagerTruststoreFileName'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_TRUSTSTORE_PASSWORD"       'Message' 'ManagerTruststorePassword'
  retrieveOption $? "$1" "$2" "$OPTION_AGENT_BASE"                        'Message' 'AgentBase'
  retrieveOption $? "$1" "$2" "$OPTION_AGENT_PASSWORD"                    'Message' 'AgentPassword'
  retrieveOption $? "$1" "$2" "$OPTION_WEBLOGIC_PORT"                     'Message' 'WeblogicPort' 'WeblogicPortDescription'
  retrieveOption $? "$1" "$2" "$OPTION_WEBLOGIC_PASSWORD"                 'Message' 'WeblogicPassword'
  retrieveOption $? "$1" "$2" "$OPTION_SYSTEMD_SERVICE"                   'Message' 'SystemdService'
  local -i Retcode=$?
  local -r Repository="${StageDirectory}/manager-${Version}"
  local -r RepositoryDescription="${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} installation repository directory"
  local -r Extractor="${Repository}/em13500_linux64.bin"
  local -r ExtractorDescription="${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} extraction program"
  local -r RootInstaller="${HomeDirectory}/allroot.sh"
  local -r RootInstallerDescription="${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} root installer program"
  local -r MarkerRepositoryExtracted="${Repository}/INSTALLATION_STEP_REPOSITORY_EXTRACTED"
  local -r MarkerManagerExtracted="${HomeDirectory}/INSTALLATION_STEP_MANAGER_EXTRACTED"
  local -r MarkerManagerInstalled="${HomeDirectory}/INSTALLATION_STEP_MANAGER_INSTALLED"
  local -r MarkerRootConfigured="${HomeDirectory}/INSTALLATION_STEP_ROOT_CONFIGURED"
  local -r MarkerFirewalldConfigured="${HomeDirectory}/INSTALLATION_STEP_FIREWALLD_CONFIGURED"
  local -r MarkerOPatchUpdated="${HomeDirectory}/INSTALLATION_STEP_OPATCH_UPDATED"
  local -r MarkerOMSPatcherUpdated="${HomeDirectory}/INSTALLATION_STEP_OMSPATCHER_UPDATED"
  local -r MarkerPatchApplied="${HomeDirectory}/PATCH_APPLIED"
  local -i bRepositoryCreated=$VALUE_FALSE
  local -i bResponseCreated=$VALUE_FALSE
  local -a FileNames
  local FileName=''

  if [[ $RETCODE_SUCCESS -ne $Retcode ]] ; then
    echo "$Message"
    return $Retcode
  fi

  ########################################
  # Extraction of the package zip files. #
  ########################################

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoSection "Extraction of the ${DESCRIPTION_MANAGER_FILES}"
  fi

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$MarkerManagerExtracted"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} is already extracted"
    else
      echoCommandMessage "the ${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} has not been extracted"
      executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$MarkerRepositoryExtracted"
      if [[ 0 -eq $? ]] ; then
        echoCommandMessage "the ${ExtractorDescription} is already extracted"
      else
        echoCommandMessage "the ${ExtractorDescription} has not been extracted"

        ### Validate that the staging directory is accessible. ###

        executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-d' "$StageDirectory" '-a' '-w' "$StageDirectory"
        processCommandCode $? "the ${StageDirectoryDescription} does not exist or is inaccessible" "$StageDirectory"
        Retcode=$?

        ### (Re-)create the manager repository directory. ###

        createDirectory $? "$User" "$Group" '755' "$RepositoryDescription" "$Repository" '' '' $VALUE_TRUE
        Retcode=$?
        if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
          bRepositoryCreated=$VALUE_TRUE
        fi

        ### Read the names of the the manager package zip files. ###

        if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
          echoCommand "IFS=',' read -ra <<< ${PackagesFileNames}"
          IFS=',' read -ra FileNames <<< "$PackagesFileNames"
          processCommandCode $? "failed to read ${PackagesFileNamesDescription}" "$OPTION_MANAGER_PACKAGES_FILE_NAMES"
          Retcode=$?
        fi

        ### Validate that the manager package zip files are accessible. ###

        for FileName in ${FileNames[@]} ; do
          if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
            executeCommand 'sudo' 'test' '-f' "$FileName" '-a' '-r' "$FileName"
            processCommandCode $? "the ${DESCRIPTION_MANAGER_FILE} does not exist or is inaccessible" "$FileName"
            Retcode=$?
          fi
        done

        ### Unzip the manager package zip files to the manager repository directory. ###

        for FileName in ${FileNames[@]} ; do
          extractFile $Retcode "$User" "$Group" "$DESCRIPTION_MANAGER_FILE" "$FileName" "$RepositoryDescription" "$Repository"
          Retcode=$?
        done

        ### Change the file ownership of the manager repository directory. ###

        setDirectoryOwnership $Retcode "$User" "$Group" "$RepositoryDescription" "$Repository"

        ### Create indicator that the Oracle Enterprise Manager package zip files have been unzipped. ###

        createMarker $? "$User" "$Group" "$MarkerRepositoryExtracted"
        Retcode=$?
      fi
    fi
  fi

  #####################################################################################
  # Generation of the Oracle Enterprise Manager automated installation response file. #
  #####################################################################################

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoSection "Generation of the ${DESCRIPTION_MANAGER_RESPONSE_FILE}"
  fi

  ### Generate the response file. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$MarkerManagerInstalled"
    if [[ 0 -eq $? ]] && false ; then
      echoCommandMessage "the ${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} is already installed and configured"
    else
      echoCommandMessage "the ${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} has not been installed or configured"
      echoInfo "a ${DESCRIPTION_MANAGER_RESPONSE_FILE} will be generated" "$ResponseFileName"
      executeCommand sudo '-u' "$User" '-g' "$Group" 'test' '-r' "$ResponseFileName"
      if [[ 0 -eq $? ]] ; then
        echoCommandMessage "The ${DESCRIPTION_MANAGER_RESPONSE_FILE} already exists and will be overwritten" "$ResponseFileName"
      else
        echoCommandMessage "The ${DESCRIPTION_MANAGER_RESPONSE_FILE} does not exist" "$ResponseFileName"
      fi
      echoCommand 'sudo' '-u' "$User" '-g' "$Group" "cat > '${ResponseFileName}' <<EOF ... EOF"
      echo "cat > '${ResponseFileName}' <<EOF
RESPONSEFILE_VERSION=2.2.1.0.0
UNIX_GROUP_NAME=${Group}
# Installation
INSTALL_UPDATES_SELECTION=skip
b_upgrade=false
EM_INSTALL_TYPE=NOSEED
CONFIGURATION_TYPE=LATER
EMPREREQ_AUTO_CORRECTION=true
CONFIGURE_ORACLE_SOFTWARE_LIBRARY=false
INVENTORY_LOCATION=${InventoryDirectory}
# Weblogic
ORACLE_MIDDLEWARE_HOME_LOCATION=${HomeDirectory}
ORACLE_HOSTNAME=${Hostname}
WLS_ADMIN_SERVER_USERNAME=weblogic
WLS_ADMIN_SERVER_PASSWORD=${WeblogicPassword}
WLS_ADMIN_SERVER_CONFIRM_PASSWORD=${WeblogicPassword}
NODE_MANAGER_PASSWORD=${WeblogicPassword}
NODE_MANAGER_CONFIRM_PASSWORD=${WeblogicPassword}
ORACLE_INSTANCE_HOME_LOCATION=${InstanceDirectory}
# Repository
DATABASE_HOSTNAME=${Hostname}
LISTENER_PORT=${DatabasePort}
SERVICENAME_OR_SID=${DatabaseName}
SYS_PASSWORD=${DatabasePassword}
DEPLOYMENT_SIZE=SMALL
SYSMAN_PASSWORD=${ManagerPassword}
SYSMAN_CONFIRM_PASSWORD=${ManagerPassword}
MANAGEMENT_TABLESPACE_LOCATION=${DatabaseData}/mgmt.dbf
CONFIGURATION_DATA_TABLESPACE_LOCATION=${DatabaseData}/mgmt_ecm_depot1.dbf
JVM_DIAGNOSTICS_TABLESPACE_LOCATION=${DatabaseData}/mgmt_deepdive.dbf
# Agent
AGENT_BASE_DIR=${AgentBase}
AGENT_REGISTRATION_PASSWORD=${AgentPassword}
AGENT_REGISTRATION_CONFIRM_PASSWORD=${AgentPassword}
# TLS
es_oneWaySSL=false
Is_twoWaySSL=true
TRUSTSTORE_PASSWORD=${ManagerTruststorePassword}
TRUSTSTORE_LOCATION=${ManagerTruststoreFileName}
KEYSTORE_PASSWORD=${ManagerKeystorePassword}
KEYSTORE_LOCATION=${ManagerKeystoreFileName}
EOF" | sudo '-u' "$User" '-g' "$Group" 'sh'
      processCommandCode $? "The ${DESCRIPTION_MANAGER_RESPONSE_FILE} was not created" "$ResponseFileName"
      Retcode=$?
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        bResponseCreated=$VALUE_TRUE
      fi
      # Restrict the file permissions of the response file.
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'sudo' 'chmod' ${ResponseFilePermissions} "$ResponseFileName"
        processCommandCode $? "Failed to restrict the file permissions to ${ResponseFilePermissionsDescription} on the ${DESCRIPTION_MANAGER_RESPONSE_FILE}" "$ResponseFileName"
        Retcode=$?
      fi
      # Validate that the response file is accessible by the installation user.
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-r' "$ResponseFileName"
        processCommandCode $? "the ${DESCRIPTION_MANAGER_RESPONSE_FILE} is inaccessible" "$ResponseFileName"
        Retcode=$?
      fi
    fi
  fi

  ##################i#########################################################
  # Extraction, patching, and installation of the Oracle Enterprise Manager. #
  ############################################################################

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoSection "Installation of the ${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]}"
  fi

  ### Change the current working directory to the Oracle Enterprise Manager software repository. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    if [[ ! -d "$Repository" ]] || [[ ! -x "$Repository" ]] ; then
      echoError $RETCODE_OPERATION_ERROR "the ${RepositoryDescription} does not exist or is inaccessible" "$Repository"
    else
      echoCommand 'cd' "$Repository"
      cd "$Repository"
      processCommandCode $? "failed to change the current working directory to the ${RepositoryDescription}" "$Repository"
    fi
    Retcode=$?
  fi

  ### Export the ORACLE_HOME environment variable. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoCommand 'export' "ORACLE_HOME=${HomeDirectory}"
    export ORACLE_HOME="$HomeDirectory"
    processCommandCode $? 'failed to export the environment variable ORACLE_HOME' "$HomeDirectory"
    Retcode=$?
  fi

  ### Export the OMS_INSTANCE_HOME environment variable. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoCommand 'export' "OMS_INSTANCE_HOME=${InstanceDirectory}"
    export OMS_INSTANCE_HOME="$InstanceDirectory"
    processCommandCode $? 'failed to export the environment variable OMS_INSTANCE_HOME' "$InstanceDirectory"
    Retcode=$?
  fi

  ### Extract the Oracle Enterprise Manager. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$MarkerManagerExtracted"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} is already extracted" "$HomeDirectory"
    else
      echoCommandMessage "the ${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} has not been extracted" "$HomeDirectory"
      executeCommand 'sudo' '-E' '-u' "$User" '-g' "$Group" "$Extractor" '-silent' '-responseFile' "$ResponseFileName" "-J-Djava.io.tmpdir=${StageDirectory}"
      processCommandCode $? "an error occurred when running the ${ExtractorDescription}" "$Extractor"
      createMarker $? "$User" "$Group" "$MarkerManagerExtracted"
    fi
    Retcode=$?
  fi

  ### Update the patchers. ###

  updatePatcher \
    $Retcode \
    "$User" \
    "$Group" \
    "$DESCRIPTION_MANAGER_OPATCH" \
    "$DESCRIPTION_MANAGER_OPATCH_FILE" \
    "$OPatchFileName" \
    "$DESCRIPTION_MANAGER_OPATCH_HOME" \
    "${HomeDirectory}/OPatch" \
    "$MarkerOPatchUpdated"
  Retcode=$?

  updatePatcher \
    $Retcode \
    "$User" \
    "$Group" \
    "$DESCRIPTION_MANAGER_OMSPATCHER" \
    "$DESCRIPTION_MANAGER_OMSPATCHER_FILE" \
    "$OMSPatcherFileName" \
    "$DESCRIPTION_MANAGER_OMSPATCHER_HOME" \
    "${HomeDirectory}/OMSPatcher" \
    "$MarkerOMSPatcherUpdated"
  Retcode=$?

  ### Extract and install the patches. ###

  local PatchHome=''
  local PatchNumber=''
  local PatchMarker=''

  if [[ -n "$PatchesFileNames" ]] ; then
    FileNames=()
    if [[ 0 -eq $Retcode ]] ; then
      echoCommand "IFS=',' read -ra <<< ${PatchesFileNames}"
      IFS=',' read -ra FileNames <<< "$PatchesFileNames"
      processCommandCode $? "failed to read ${PatchesFileNamesDescription}" "$OPTION_MANAGER_PACKAGES_FILE_NAMES"
      Retcode=$?
    fi
    for FileName in ${FileNames[@]} ; do
      extractPatch \
        'PatchHome' \
        'PatchNumber' \
        'PatchMarker' \
        "$User" \
        "$Group" \
        '755' \
        "$DESCRIPTION_MANAGER_PATCH" \
        "$DESCRIPTION_MANAGER_PATCH_FILE" \
        "$FileName" \
        "$PatchesFileNamesDescription" \
        "${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} patch staging directory" \
        "${StageDirectory}/${PRODUCT_MANAGER}-patches" \
        "$MarkerPatchApplied"
      Retcode=$?
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ -n "$PatchHome" ]] ; then
        export ORACLE_HOME="$HomeDirectory"
        cd "$PatchHome"
        executeCommand 'sudo' '-E' '-u' "$User" '-g' "$Group" "${ORACLE_HOME}/OPatch/opatch" 'apply' '-silent'
        processCommandCode $? "failed to apply ${DESCRIPTION_MANAGER_PATCH}"  "$PatchNumber"
        createMarker $? "$User" "$Group" "$PatchMarker"
        Retcode=$?
      fi
      if [[ $RETCODE_SUCCESS -ne $Retcode ]] ; then
        break
      fi
    done
  fi

  ### Upgrade the Oracle Enteprise Manager. ###

  if [[ -n "$UpgradePatchFileName" ]] ; then
    extractPatch \
      'PatchHome' \
      'PatchNumber' \
      'PatchMarker' \
      "$User" \
      "$Group" \
      '755' \
      "$DESCRIPTION_MANAGER_UPGRADE_PATCH" \
      "$DESCRIPTION_MANAGER_UPGRADE_PATCH_FILE" \
      "$UpgradePatchFileName" \
      "$UpgradePatchFileNameDescription" \
      "${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} patch staging directory" \
      "${StageDirectory}/${PRODUCT_MANAGER}-patches" \
      "$MarkerPatchApplied"
    Retcode=$?
    if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ -n "$PatchHome" ]] ; then
      executeCommand 'sudo' '-u' "$User" '-g' "$Group" "${HomeDirectory}/OMSPatcher/omspatcher" 'apply' "$PatchHome" '-analyze' '-bitonly' '-silent' '-oh' "$HomeDirectory"
      processCommandCode $? "failed to apply ${DESCRIPTION_MANAGER_UPGRADE_PATCH}"  "$PatchNumber"
      createMarker $? "$User" "$Group" "$PatchMarker"
      Retcode=$?
    fi
  fi

  ########################################
  # Perform the post-installation steps. #
  ########################################

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoSection "Post-installation steps"
  fi

  ### Delete the Oracle Enterprise Manager automated installation response file. ###

#  if [[ $VALUE_TRUE -eq $bResponseCreated ]] ; then
#    executeCommand sudo '-u' "$User" '-g' "$Group" 'test' '-f' "$ResponseFileName"
#    if [[ 0 -eq $? ]] ; then
#      echoCommandMessage "the ${DESCRIPTION_MANAGER_RESPONSE_FILE} will be deleted" "$ResponseFileName"
#      executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'rm' "$ResponseFileName"
#      processCommandCode $? "failed to the delete the ${DESCRIPTION_MANAGER_RESPONSE_FILE}" "$ResponseFileName"
#    else
#      echoCommandMessage "the ${DESCRIPTION_MANAGER_RESPONSE_FILE} does not exist" "$ResponseFileName"
#    fi
#  fi

  ### Run the Oracle Enterprise Manager root installer program using the root user. ###

#  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
#    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$MarkerRootConfigured"
#    if [[ 0 -eq $? ]] ; then
#      echoCommandMessage "the ${RootInstallerDescription} has already been run" "$RootInstaller"
#      Retcode=$?
#    else
#      echoCommandMessage "the ${RootInstallerDescription} has not already been run" "$RootInstaller"
#      executeCommand 'sudo' '-E' '-u' "$User" '-g' "$Group" 'sudo' 'test' '-x' "$RootInstaller"
#      processCommandCode $? "the ${RootInstallerDescription} does not exist or is inaccessible" "$RootInstaller"
#      Retcode=$?
#      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
#        executeCommand 'sudo' '-E' '-u' "$User" '-g' "$Group" 'sudo' '-E' "$RootInstaller"
#        processCommandCode $? "an error occurred when running the ${RootInstallerDescription}" "$RootInstaller"
#        createMarker $? "$User" "$Group" "$MarkerRootConfigured"
#        Retcode=$?
#      fi
#    fi
#  fi

  ### Configure firewalld to allow network access to the Oracle Enterprise Manager. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$MarkerFirewalldConfigured"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "Firewalld has already been configured for the ${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]}"
      Retcode=$?
    else
      echoCommandMessage "Firewalld has not already been configured for the ${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]}"
      executeCommand 'sudo' 'systemctl' 'status' 'firewalld'
      if [[ 0 -eq $? ]] ; then
        echoCommandSuccess
        executeCommand 'sudo' 'firewall-cmd' '--permanent' '--zone=public' "--add-port=${WeblogicPort}/tcp"
        processCommandCode $? "failed to allow public access to the ${WeblogicPortDescription}" "$WeblogicPort"
        Retcode=$?
        if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
          executeCommand 'sudo' 'firewall-cmd' '--permanent' '--zone=public' "--add-port=${ManagerPort}/tcp"
          processCommandCode $? "failed to allow public access to the ${ManagerPortDescription}" "$ManagerPort"
          Retcode=$?
        fi
        if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
          executeCommand 'sudo' 'firewall-cmd' '--reload'
          processCommandCode $? 'failed to reload firewalld'
          createMarker $? "$User" "$Group" "$MarkerFirewalldConfigured"
          Retcode=$?
        fi
      else
        echoCommandMessage 'Firewalld may not be running'
        Retcode=$?
      fi
    fi
  fi

  return $Retcode
}

################################################################################
## @fn prepareInstallation
##
## @brief Prepare the system for the installation of the Oracle products.
##
## @param[in] Sources The name of the variable that contains the sources of the
##                    program option values.
## @param[in] Values  The name of the vatiable that contains the program option
##                    values.
##
## @note This function performs the following steps:
##
## @li Creation of the installation operating system group and user.
## @li Addition of the installation user to the list of the system sudoers.
## @li Installation of the system libraries.
## @li Adjustment of the system swap.
## @li Configuration of Systctl.
## @li Configuration of the system limits.
## @li Creation of the Oracle products installation directories. 
## @li Creation of the Systemd service for the Oracle Database.
##
## @return The return code of the function execution.
################################################################################
prepareInstallation() {
  local Message=''
  local Capture=''
  local InstallationStage         DescriptionInstallationStage
  local InstallationInventory     DescriptionInstallationInventory
  local InstallationBase          DescriptionInstallationBase
  local InstallationPermissions   DescriptionInstallationPermissions
  local User                      DescriptionUser
  local Group                     DescriptionGroup
  local Hostname
  local DatabaseHome              DescriptionDatabaseHome
  local DatabaseName
  local DBAGroup                  DescriptionDBAGroup
  local ManagerVersion
  local ManagerHome               DescriptionManagerHome
  local ManagerInstance           DescriptionManagerInstance
  local AgentBase                 DescriptionAgentBase
  local SudoersFileName
  local SudoersFilePermissions    DescriptionSudoersFilePermissions
  local SwapGoal                  DescriptionSwapGoal
  local SwapFileName
  local SwapFilePermissions       DescriptionSwapFilePermissions
  local SysctlFileName
  local SysctlFilePermissions     DescriptionSysctlFilePermissions
  local LimitsFileName
  local LimitsFilePermissions     DescriptionLimitsFilePermissions
  local ControlLerFileName
  local ControlLerFilePermissions DescriptionControllerFilePermissions
  local SystemdService            DescriptionSystemdService
  local SystemdFileName
  local SystemdFilePermissions    DescriptionSystemdFilePermissions
  echoTitle 'Preparing for installation of the Oracle products'
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_STAGE"            'Message' 'InstallationStage'         'DescriptionInstallationStage'
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_INVENTORY"        'Message' 'InstallationInventory'     'DescriptionInstallationInventory'
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_BASE"             'Message' 'InstallationBase'          'DescriptionInstallationBase'
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_FILE_PERMISSIONS" 'Message' 'InstallationPermissions'   'DescriptionInstallationPermissions'
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_USER"             'Message' 'User'                      'DescriptionUser'
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_GROUP"            'Message' 'Group'                     'DescriptionGroup'
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_HOSTNAME"         'Message' 'Hostname'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_HOME"                 'Message' 'DatabaseHome'              'DescriptionDatabaseHome'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_NAME"                 'Message' 'DatabaseName'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_ADMINISTRATOR_GROUP"  'Message' 'DBAGroup'                  'DescriptionDBAGroup'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_VERSION"               'Message' 'ManagerVersion'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_HOME"                  'Message' 'ManagerHome'               'DescriptionManagerHome'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_INSTANCE"              'Message' 'ManagerInstance'           'DescriptionManagerInstance'
  retrieveOption $? "$1" "$2" "$OPTION_AGENT_BASE"                    'Message' 'AgentBase'                 'DescriptionAgentBase'
  retrieveOption $? "$1" "$2" "$OPTION_SUDOERS_FILE_NAME"             'Message' 'SudoersFileName'
  retrieveOption $? "$1" "$2" "$OPTION_SUDOERS_FILE_PERMISSIONS"      'Message' 'SudoersFilePermissions'    'DescriptionSudoersFilePermissions'
  retrieveOption $? "$1" "$2" "$OPTION_SWAP_GOAL"                     'Message' 'SwapGoal'                  'DescriptionSwapGoal'
  retrieveOption $? "$1" "$2" "$OPTION_SWAP_FILE_NAME"                'Message' 'SwapFileName'
  retrieveOption $? "$1" "$2" "$OPTION_SWAP_FILE_PERMISSIONS"         'Message' 'SwapFilePermissions'       'DescriptionSwapFilePermissions'
  retrieveOption $? "$1" "$2" "$OPTION_SYSCTL_FILE_NAME"              'Message' 'SysctlFileName'
  retrieveOption $? "$1" "$2" "$OPTION_SYSCTL_FILE_PERMISSIONS"       'Message' 'SysctlFilePermissions'     'DescriptionSysctlFilePermissions'
  retrieveOption $? "$1" "$2" "$OPTION_LIMITS_FILE_NAME"              'Message' 'LimitsFileName'
  retrieveOption $? "$1" "$2" "$OPTION_LIMITS_FILE_PERMISSIONS"       'Message' 'LimitsFilePermissions'     'DescriptionLimitsFilePermissions'
  retrieveOption $? "$1" "$2" "$OPTION_CONTROLLER_FILE_NAME"          'Message' 'ControllerFileName'
  retrieveOption $? "$1" "$2" "$OPTION_CONTROLLER_FILE_PERMISSIONS"   'Message' 'ControllerFilePermissions' 'DescriptionControllerFilePermissions'
  retrieveOption $? "$1" "$2" "$OPTION_SYSTEMD_SERVICE"               'Message' 'SystemdService'            'DescriptionSystemdService'
  retrieveOption $? "$1" "$2" "$OPTION_SYSTEMD_FILE_NAME"             'Message' 'SystemdFileName'
  retrieveOption $? "$1" "$2" "$OPTION_SYSTEMD_FILE_PERMISSIONS"      'Message' 'SystemdFilePermissions'    'DescriptionSystemdFilePermissions'
  local -i bUserCreated=$VALUE_FALSE
  local -i Retcode=$?

  if [[ $RETCODE_SUCCESS -ne $Retcode ]] ; then
    echo "$Message"
    return $Retcode
  fi

  #####################################################
  # Creation of the operating system user and groups. #
  #####################################################

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoSection "Creation of the operating system user and group: ${User}:${Group}"
  fi

  ### Create the installation group. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand2 'Capture' 'sudo' 'getent' 'group' "$Group"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${DescriptionGroup} already exists" "$Group" "$Capture"
    else
      echoCommandMessage "the ${DescriptionGroup} does not exist" "$Group" "$Capture"
      executeCommand 'sudo' '/usr/sbin/groupadd' '-g' '54321' "$Group"
      processCommandCode $? "failed to create the ${DescriptionGroup}" "$Group"
    fi
    Retcode=$?
  fi

  ### Create the database administrator group. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand2 'Capture' 'sudo' 'getent' 'group' "$DBAGroup"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${DescriptionDBAGroup} already exists" "$DBAGroup" "$Capture"
    else
      echoCommandMessage "the ${DescriptionDBAGroup} does not exist" "$DBAGroup" "$Capture"
      executeCommand 'sudo' '/usr/sbin/groupadd' '-g' '54322' "$DBAGroup"
      processCommandCode $? "failed to create the ${DescriptionDBAGroup}" "$DBAGroup"
    fi
    Retcode=$?
  fi

  ### Create the installation user. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    local Output1=''
    local Output2=''
    echoCommand 'id' "$User"
    Output1=$(id "$User")
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${DescriptionUser} already exists" "$User"
      echoCommand 'echo' "$Output1" '|' 'awk' "-F ' ' '{ print \$2 }'" '|' 'awk' "-F '(' '{ print \$2 }'" '|' 'tr' "-d' ')'"
      Output2=$(echo "$Output1" | awk -F ' ' '{ print $2 }' | awk -F '(' '{ print $2 }' | tr -d ')')
      processCommandCode $? "failed to validate group membership of the ${DescriptionUser}" "$User"
      Retcode=$?
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        if [[ "$Group" == "$Output2" ]] ; then
          echoInfo "the primary group of the ${DescriptionUser} '${User}' is the ${DescriptionGroup}" "$Group"
        else
          echoError $RETCODE_OPERATION_ERROR "the primary group of the ${DescriptionUser} '${User}' is not the ${DescriptionGroup}" "$Group" "$Output2"
        fi
        Retcode=$?
      fi
    else
      echoCommandMessage "the ${DescriptionUser} does not exist" "$User"
      executeCommand 'sudo' '/usr/sbin/useradd' '-u' '54321' '-g' "$Group" '-s' '/bin/bash' '-m' "$User"
      processCommandCode $? "failed to create the ${DescriptionUser}" "${User}:${Group}"
      Retcode=$?
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        bUserCreated=$VALUE_TRUE
      fi
    fi
  fi

  ### Confirm that the installation user is member of the database administrator group. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    local Output3=''
    local Output4=''
    echoCommand 'sudo' 'getent' 'group' "$DBAGroup"
    Output3=$(sudo getent 'group' "$DBAGroup")
    processCommandCode $? "the ${DescriptionDBAGroup} does not exist" "$DBAGroup"
    Retcode=$?
    if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
      echoCommand 'echo' "$Output3" '|' 'awk' '-F' ':' '{ print $4}'
      Output4=$(echo "$Output3" | awk -F ':' '{ print $4}')
      if [[ 0 -eq $? ]] && [[ "$User" == "$Output4" ]] ; then
        echoCommandMessage "the ${DescriptionUser} '${User}' is already a member of the ${DescriptionDBAGroup}" "$DBAGroup"
      else
        echoCommandMessage "the ${DescriptionUser} '${User}' is not a member of the ${DescriptionDBAGroup}" "$DBAGroup" "$Output4"
        executeCommand 'sudo' 'usermod' '-a' '-G' "$DBAGroup" "$User"
        processCommandCode $? "failed to add the ${DescriptionUser} '${User}' to the ${DescriptionDBAGroup}" "$DBAGroup"
      fi
      Retcode=$?
    fi
  fi

  ### Retrieve the home directory of the installation user. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    local Output5=''
    echoCommand 'sudo' 'getent' 'passwd' "$User" '|' 'cut' '-d:' '-f6'
    Output5="$(getent 'passwd' ${User} | cut '-d:' '-f6')"
    local ExitCode=$?
    if [[ 0 -eq $ExitCode ]] && [[ -z "$Output5" ]] ; then
      ExitCode=2
    fi
    processCommandCode $ExitCode "failed to determine the home directory of the ${DescriptionUser}" "$User"
    Retcode=$?
    if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
      echoInfo "the home directory of the ${DescriptionUser} '${User}'" "$Output5"
      executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-d' "$Output5"
      processCommandCode $? "failed to access the home directory of the ${DescriptionUser} (${User})" "$Output5"
      Retcode=$?
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        local -r UserHome="$Output5"
      fi
    fi
  fi

  ### Update the .bashrc of the new installation user. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    appendLine $Retcode "${UserHome}/.bashrc" 'export PATH="/usr/local/bin:\${PATH}"'
    appendLine $?       "${UserHome}/.bashrc" "export ORACLE_HOSTNAME='${Hostname}'"
    appendLine $?       "${UserHome}/.bashrc" "export ORACLE_SID='${DatabaseName}'"
    appendLine $?       "${UserHome}/.bashrc" "export ORACLE_HOME='${DatabaseHome}'"
    appendLine $?       "${UserHome}/.bashrc" "export OMS_HOME='${ManagerHome}'"
    appendLine $?       "${UserHome}/.bashrc" "export AGENT_HOME='${AgentBase}/agent_${ManagerVersion}'"
    Retcode=$?
  fi

  ### Add the installation user to the operating systems's list of sudoers. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' 'test' '-r' "$SudoersFileName"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${DESCRIPTION_SUDOERS_FILE} already exists" "$SudoersFileName"
      Retcode=$?
    else
      echoCommandMessage "the ${DESCRIPTION_SUDOERS_FILE} does not exist" "$SudoersFileName"
      echoCommand 'sudo' "cat > ${SudoersFileName} <<EOF ... EOF"
      echo "cat > '${SudoersFileName}' <<EOF
# Created by ${PROGRAM} on $(date)
# Grant sudo privileges to the Oracle installation user
${User} ALL=(ALL) NOPASSWD:ALL
EOF" | sudo 'sh'
      processCommandCode $? "failed to create the ${DESCRIPTION_SUDOERS_FILE}" "$SudoersFileName"
      Retcode=$?
      # Restrict the file permissions of the Oracle Database automated installation response file.
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'sudo' 'chmod' "$SudoersFilePermissions" "$SudoersFileName"
        processCommandCode $? "failed to restrict the ${DescriptionSudoersFilePermissions} to '${SudoersFilePermissions}'" "$SudoersFileName"
        Retcode=$?
      fi
    fi
  fi

  ### Validate that the installation user sudoers supplementary file exists. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' 'test' '-f' "$SudoersFileName"
    processCommandCode $? "the ${DESCRIPTION_SUDOERS_FILE} is inaccessible" "$SudoersFileName"
    Retcode=$?
  fi

  ##################################################
  # Installation of the required system libraries. #
  ##################################################

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoSection 'Installation of the required system libraries'
  fi

  ### Install pre-requisite system libraries. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    if ! [[ -f '/usr/lib64/libnsl.so.1' ]] ; then
      executeCommand 'sudo' 'yum' '-y' 'install' 'libnsl'
      processCommandCode $? 'failed to install the pre-requisite system library' 'libnsl'
      Retcode=$?
    fi
  fi

  #D######################################################
  # Adjustment of the system swap to have at least 16GB. #
  ########################################################

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoSection "Adjustment of the ${DESCRIPTION_SWAP} for at least ${SwapGoal}GB"
  fi

  ### Add an extra system swap file, if needed. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    local SwapString=''
    echoCommand 'sudo' 'swapon' '--show' '--raw' '--noheadings' '|' 'awk' '-F' "' '" "'BEGIN{ Total = 0 } { if ( ${CHARACTER_DOUBLE_QUOTE}G${CHARACTER_DOUBLE_QUOTE} == substr(\$3,length(\$3),1) ) Total += substr(\$3,1,length(\$3)-1) } END{ print Total }'"
    SwapString=`sudo swapon '--show' '--raw' '--noheadings' | awk '-F' ' ' 'BEGIN{ Total = 0} { if ( "G" == substr($3,length($3),1) ) Total+=int(substr($3,1,length($3)-1)) } END{ print Total }'`
    processCommandCode $? "failed to ascertain the ${DESCRIPTION_SWAP} size"
    if [[ $RETCODE_SUCCESS -eq $? ]] && [[ -n "$SwapString" ]] && [[ "$SwapString" =~ ^[0-9]+$ ]] ; then
      local -r -i SwapSize=$SwapString
      echoInfo "${DESCRIPTION_SWAP}" "${SwapSize}GB"
      echoInfo "${DescriptionSwapGoal}" "${SwapGoal}GB"
    else
      local -r -i SwapSize=0
    fi
    if [[ 0 -ge $SwapSize ]] ; then
      echoInfo "${DESCRIPTION_SWAP} not adjusted: failed to determine current size" '' "$SwapSize"
    elif [[ $SwapGoal -le $SwapSize ]] ; then
      echoInfo "${DESCRIPTION_SWAP} not adjusted: already large enough"
    else
      local -r -i SwapIncrease=$(($SwapGoal-$SwapSize))
      local -i bSwapCreated=$VALUE_FALSE
      local -i bSwapAdded=$VALUE_FALSE
      echoInfo "${DESCRIPTION_SWAP} increase" "${SwapIncrease}GB"
      executeCommand 'sudo' 'fallocate' '-l' "${SwapIncrease}G" "$SwapFileName"
      processCommandCode $? "failed to allocate ${DESCRIPTION_SWAP_FILE}" "$SwapFileName"
      Retcode=$?
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        bSwapCreated=$VALUE_TRUE
        executeCommand 'sudo' 'chmod' "$SwapFilePermissions" "$SwapFileName"
        processCommandCode $? "failed to restrict the ${DescriptionSwapFilePermissions} to '${SwapFilePermissions}'" "$SwapFileName"
        Retcode=$?
      fi
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'sudo' 'mkswap' "$SwapFileName"
        processCommandCode $? "failed to format ${DESCRIPTION_SWAP_FILE}" "$SwapFileName"
        Retcode=$?
      fi
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'sudo' 'swapon' "$SwapFileName"
        processCommandCode $? "failed to add ${DESCRIPTION_SWAP_FILE} to ${DESCRIPTION_SWAP}" "$SwapFileName"
        Retcode=$?
        if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
          bSwapAdded=$VALUE_TRUE
        fi
      fi
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'grep' '-e' "^${SwapFileName}[[:space:]]" "$FSTAB_FILE_NAME"
        if [[ 0 -eq $? ]] ; then
          echoCommandMessage "a ${DESCRIPTION_SWAP_FILE} entry already exists in ${FSTAB_FILE_NAME}" "$SwapFileName"
        else
          echoCommandSuccess
          echoCommand 'sudo' 'sh' '-c' "echo '-e' '${SwapFileName}\tnone\tswap\tsw\t0\t0' >> '${FSTAB_FILE_NAME}'"
          sudo 'sh' '-c' "echo -e '${SwapFileName}\tnone\tswap\tsw\t0\t0' >> '${FSTAB_FILE_NAME}'"
          processCommandCode $? "failed to add entry to ${FSTAB_FILE_NAME} for the ${DESCRIPTION_SWAP_FILE}" "$SwapFileName"
        fi
        Retcode=$?
      fi
      if [[ $RETCODE_SUCCESS -ne $Retcode ]] && [[ $VALUE_TRUE -eq $bSwapAdded ]] ; then
        executeCommand 'sudo' 'swapoff' "$SwapFileName"
        processCommandCode $? "failed to remove ${DESCRIPTION_SWAP_FILE}" "$SwapFileName"
      fi
      if [[ $RETCODE_SUCCESS -ne $Retcode ]] && [[ $VALUE_TRUE -eq $bSwapCreated ]] ; then
        executeCommand 'sudo' 'rm' "$SwapFileName"
        processCommandCode $? "failed to delete ${DESCRIPTION_SWAP_FILE}" "$SwapFileName"
      fi
    fi
  fi

  #################################################################
  # Configuration of the Sysctl settings for the Oracle Database. #
  #################################################################

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoSection "Configuration of the ${DESCRIPTION_SYSCTL}"
  fi

  ### Create and activate the Systctl settings for the Oracle Database. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' 'root' '-g' 'root' 'test' '-f' "$SysctlFileName"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${DESCRIPTION_SYSCTL_FILE} already exists" "$SysctlFileName"
    else
      echoCommandMessage "the ${DESCRIPTION_SYSCTL_FILE} does not exist" "$SysctlFileName"
      echoCommand 'sudo' '-u' 'root' '-g' 'root' "cat > '${SysctlFileName}' <<EOF ... EOF"
      echo "cat > '${SysctlFileName}' <<EOF
# Created by ${PROGRAM} on $(date)
fs.file-max = 6815744
kernel.sem = 250 32000 100 128
kernel.shmmni = 4096
kernel.shmall = 1073741824
kernel.shmmax = 4398046511104
kernel.panic_on_oops = 1
net.core.rmem_default = 262144
net.core.rmem_max = 4194304
net.core.wmem_default = 262144
net.core.wmem_max = 1048576
net.ipv4.conf.all.rp_filter = 2
net.ipv4.conf.default.rp_filter = 2
fs.aio-max-nr = 1048576
net.ipv4.ip_local_port_range = 9000 65500
EOF" | sudo '-u' 'root' '-g' 'root' 'sh'
      processCommandCode $? "failed to create the ${DESCRIPTION_SYSCTL_FILE}" "$SysctlFileName"
      Retcode=$?
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'sudo' 'chmod' "$SysctlFilePermissions" "$SysctlFileName"
        processCommandCode $? "failed to restrict the ${DescriptionSysctlFilePermissions} to '${SysctlFilePermissions}'" "$SysctlFileName"
        Retcode=$?
        if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
          executeCommand 'sudo' '/sbin/sysctl' '-p' "$SysctlFileName"
          processCommandCode $? "failed to activate ${DESCRIPTION_SYSCT_FILE}" "$SysctlFileName"
          Retcode=$?
        fi
      fi
    fi
  fi

  ##########################################################################################
  # Configuration of the limits settings for the installation user of the Oracle Database. #
  ##########################################################################################

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoSection "Configuration of the ${DESCRIPTION_LIMITS}"
  fi

  ### Create the limits settings for the installation user of the Oracle Database. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' 'root' '-g' 'root' 'test' '-f' "$LimitsFileName"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${DESCRIPTION_LIMITS_FILE} already exists" "$LimitsFileName"
    else
      echoCommandMessage "the ${DESCRIPTION_LIMITS_FILE} does not exist" "$LimitsFileName"
      echoCommand 'sudo' '-u' 'root' '-g' 'root' "cat > '${LimitsFileName}' <<EOF ... EOF"
      echo "cat > '${LimitsFileName}' <<EOF
# Created by ${PROGRAM} on $(date)
${User} soft nofile  1024
${User} hard nofile  65536
${User} soft nproc   16384
${User} hard nproc   16384
${User} soft stack   10240
${User} hard stack   32768
${User} hard memlock 134217728
${User} soft memlock 134217728
EOF" | sudo '-u' 'root' '-g' 'root' 'sh'
      processCommandCode $? "failed to create the ${DESCRIPTION_LIMITS_FILE}" "$LimitsFileName"
      Retcode=$?
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'sudo' 'chmod' "$LimitsFilePermissions" "$LimitsFileName"
        processCommandCode $? "failed to restrict the ${DescriptionLimitsFilePermissions} to '${LimitsFilePermissions}'" "$LimitsFileName"
        Retcode=$?
      fi
    fi
  fi

  #####################################################################
  # Creation of the installation directories for the Oracle products. #
  #####################################################################

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoSection 'Creation of the installation directories for the Oracle products'
  fi

  ### Create the installation staging directory. ###

  createDirectory $Retcode "$User" "$Group" "$InstallationPermissions" "$DescriptionInstallationStage" "$InstallationStage"
  Retcode=$?

  ### Create the installation base directory. ###

  createDirectory $Retcode "$User" "$Group" "$InstallationPermissions" "$DescriptionInstallationBase" "$InstallationBase"
  Retcode=$?

  ### Create the installation inventory directory. ###

  createDirectory $Retcode "$User" "$Group" "$InstallationPermissions" "$DescriptionInstallationInventory" "$InstallationInventory" "$DescriptionInstallationBase" "$InstallationBase"
  Retcode=$?

  ### Create the Oracle Database home directory. ###

  createDirectory $Retcode "$User" "$Group" "$InstallationPermissions" "$DescriptionDatabaseHome" "$DatabaseHome" "$DescriptionInstallationBase" "$InstallationBase"
  Retcode=$?

  ### Create the Oracle Enterprise Manager home directory. ###

  createDirectory $Retcode "$User" "$Group" "$InstallationPermissions" "$DescriptionManagerHome" "$ManagerHome" "$DescriptionInstallationBase" "$InstallationBase"
  Retcode=$?

  ### Create the Oracle Enterprise Manager instance home directory. ###

  createDirectory $Retcode "$User" "$Group" "$InstallationPermissions" "$DescriptionManagerInstance" "$ManagerInstance" "$DescriptionInstallationBase" "$InstallationBase"
  Retcode=$?

  ### Create the Oracle Enterprise Manager agent base directory. ###

  createDirectory $Retcode "$User" "$Group" "$InstallationPermissions" "$DescriptionAgentBase" "$AgentBase" "$DescriptionInstallationBase" "$InstallationBase"
  Retcode=$?

  #######################################################
  # Create the Systemd service for the Oracle Database. #
  #######################################################

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoSection "Creation of the ${DESCRIPTION_SYSTEMD_SERVICE}"
  fi

  ### Create the Oracle Database service control program. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    local -r ControllerFile="${UserHome}/${ControllerFileName}"
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-x' "$ControllerFile"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${DESCRIPTION_CONTROLLER_FILE} already exists and will be overwritten" "$ControllerFile"
    else
      echoCommandMessage "the ${DESCRIPTION_CONTROLLER_FILE} does not exist or is inaccessible" "$ControllerFile"
    fi
    echoCommand 'sudo' '-u' "$User" '-g' "$Group" "cat > '${ControllerFile}' <<EOF ... EOF"
    echo '-e' "cat > '${ControllerFile}' <<EOF
#!/usr/bin/bash

# Created by ${PROGRAM} on $(date)

declare -r ORIGINAL_PATH=${CHARACTER_DOUBLE_QUOTE}\\\$PATH${CHARACTER_DOUBLE_QUOTE}

export TMPDIR='/tmp'
export TMP='/tmp'

controlAgent() {
  local -r RESPONSE_FILE='${AgentBase}/agentInstall.rsp'
  local Log=''
  local -i Retcode=0
  if [[ -r \"\\\$RESPONSE_FILE\" ]] ; then
    export ORACLE_HOME=\\\$(grep 'ORACLE_HOME' \"\\\$RESPONSE_FILE\" | awk -F '=' '{print \\\$2}')
    local -r Command=\"\\\${ORACLE_HOME}/bin/emctl\"
    if [[ -n \"\\\$ORACLE_HOME\" ]] && [[ -x \"\\\$Command\" ]] ; then
      export PATH=\"\\\${ORACLE_HOME}/bin:/usr/local/bin:\\\${ORIGINAL_PATH}\"
      export LD_LIBRARY_PATH=\"\\\${ORACLE_HOME}/lib:/lib:/usr/lib\"
      export CLASSPATH=\"\\\${ORACLE_HOME}/jlib\"
      cd \"\\\$ORACLE_HOME\"
      Log=\\\$(\"\\\$Command\" \\\$@)
      Retcode=\\\$?
    fi
  fi
  if [[ 0 -ne \\\$Retcode ]] ; then
    echo \"\\\$Log\"
  fi
  return \\\$Retcode
}

controlDatabase() {
  export ORACLE_HOME='${DatabaseHome}'
  local -r Command=\"\\\${ORACLE_HOME}/bin/\\\$1\"
  local Log=''
  local -i Retcode=0
  if [[ -n \"\\\$ORACLE_HOME\" ]] && [[ -x \"\\\$Command\" ]] ; then
    export PATH=\"\\\${ORACLE_HOME}/bin:/usr/local/bin:\\\${ORIGINAL_PATH}\"
    export LD_LIBRARY_PATH=\"\\\${ORACLE_HOME}/lib:/lib:/usr/lib\"
    export CLASSPATH=\"\\\${ORACLE_HOME}/jlib:\\\${ORACLE_HOME}/rdbms/jlib\"
    cd \"\\\$ORACLE_HOME\"
    Log=\\\$(\"\\\$Command\" \"\\\$ORACLE_HOME\")
    Retcode=\\\$?
  fi
  if [[ 0 -ne \\\$Retcode ]] ; then
    echo \"\\\$Log\"
  fi
  return \\\$Retcode
}

controlManager() {
  export ORACLE_HOME='${ManagerHome}'
  local -r Command=\"\\\${ORACLE_HOME}/bin/emctl\"
  local Log=''
  local -i Retcode=0
  if [[ -n \"\\\$ORACLE_HOME\" ]] && [[ -x \"\\\$Command\" ]] ; then
    export PATH=\"\\\${ORACLE_HOME}/bin:/usr/local/bin:\\\${ORIGINAL_PATH}\"
    export LD_LIBRARY_PATH=\"\\\${ORACLE_HOME}/lib:/lib:/usr/lib\"
    export CLASSPATH=\"\\\${ORACLE_HOME}/jlib:\\\${ORACLE_HOME}/rdbms/jlib\"
    cd \"\\\$ORACLE_HOME\"
    Log=\\\$(\"\\\$Command\" \\\$@)
    Retcode=\\\$?
  fi
  if [[ 0 -ne \\\$Retcode ]] ; then
    echo \"\\\$Log\"
  fi
  return \\\$Retcode
}

declare Log=''
declare -i Retcode=0

if [[ 1 -ne \\\$# ]] ; then
  Log='Incorrect number of parameters.  Expected the parameters \"start\" or \"stop\" only.'
  Retcode=1
elif [[ 'start' = \"\\\$1\" ]] ; then
  if [[ 0 -eq \\\$Retcode ]] ; then
    Log=\\\$(controlDatabase 'dbstart')
    Retcode=\\\$?
  fi
  if [[ 0 -eq \\\$Retcode ]] ; then
    Log=\\\$(controlManager 'start' 'oms')
    Retcode=\\\$?
  fi
  if [[ 0 -eq \\\$Retcode ]] ; then
    Log=\\\$(controlAgent 'start' 'agent')
    Retcode=\\\$?
  fi
elif [[ 'stop' = \"\\\$1\" ]] ; then
  if [[ 0 -eq \\\$Retcode ]] ; then
    Log=\\\$(controlManager 'stop' 'oms' '-all')
    Retcode=\\\$?
  fi
  if [[ 0 -eq \\\$Retcode ]] ; then
    Log=\\\$(controlAgent 'stop' 'agent')
    Retcode=\\\$?
  fi
  if [[ 0 -eq \\\$Retcode ]] ; then
    Log=\\\$(controlDatabase 'dbshut')
    Retcode=\\\$?
  fi
else
  Log=\"[ERROR] Invalid command: \\\${1}\"
  Retcode=1
fi

if [[ 0 -ne \\\$Retcode ]] ; then
  echo \"\\\$Log\"
fi

exit \\\$Retcode
EOF" | sudo '-u' "$User" '-g' "$Group" 'sh'
    processCommandCode $? "failed to create the ${DESCRIPTION_CONTROLLER_FILE}" "$ControllerFile"
    Retcode=$?
    if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
      executeCommand 'sudo' 'chmod' "$ControllerFilePermissions" "$ControllerFile"
      processCommandCode $? "failed to restrict the ${DescriptionControllerFilePermissions} to '${ControllerFilePermissions}'" "$ControllerFile"
      Retcode=$?
    fi
  fi

  ### Create the Systemd service file for Oracle Database. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' 'root' '-g' 'root' 'test' '-f' "$SystemdFileName"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${DESCRIPTION_SYSTEMD_SERVICE_FILE} already exists and will be overwritten" "$SystemdFileName"
    else
      echoCommandMessage "the ${DESCRIPTION_SYSTEMD_SERVICE_FILE} does not exist" "$SystemdFileName"
    fi
    echoCommand 'sudo' '-u' 'root' '-g' 'root' "cat > '${SystemdFileName}' <<EOF ... EOF"
    echo "cat > '${SystemdFileName}' <<EOF
# Created by ${PROGRAM} on $(date)

[Unit]
Description=${DescriptionSystemdService}
After=syslog.target network.target

[Service]
LimitMEMLOCK=infinity
LimitNOFILE=65535
RemainAfterExit=yes
User=${User}
Group=${Group}
Restart=no
ExecStart=/usr/bin/bash -c '${ControllerFile} start'
ExecStop=/usr/bin/bash -c '${ControllerFile} stop'

[Install]
WantedBy=multi-user.target
EOF" | sudo '-u' 'root' '-g' 'root' 'sh'
    processCommandCode $? "failed to create the ${DESCRIPTION_SYSTEMD_SERVICE_FILE}" "$SystemdFileName"
    Retcode=$?
    if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
      executeCommand 'sudo' 'chmod' "$SystemdFilePermissions" "$SystemdFileName"
      processCommandCode $? "failed to restrict the ${DescriptionSystemdFilePermissions} to '${SystemdFilePermissions}'" "$SystemdFileName"
      Retcode=$?
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'sudo' 'systemctl' 'enable' "$SystemdService"
        processCommandCode $? "failed to enable the ${DESCRIPTION_SYSTEMD_SERVICE}" "$SystemdService"
        Retcode=$?
      fi
    fi
  fi

  return $Retcode
}

################################################################################
## @fn uninstallDatabase
##
## @brief Uninstall the Oracle Database.
##
## @param[in] Sources The name of the variable that contains the sources of the
##                    program option values.
## @param[in] Values  The name of the vatiable that contains the program option
##                    values.
##
## @note This function performs the following steps:
##
## @li Generation of a response file for the automated deinstallation of the
##     Oracle Database.
## @li Deinstallation of the Oracle Database.
##
## @return The return code of the function execution.
################################################################################
uninstallDatabase() {
  local Message=''
  local User
  local Group
  local DatabaseHome
  local DescriptionDatabaseHome
  echoTitle "Uninstalling the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]}"
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_USER"  'Message' 'User'
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_GROUP" 'Message' 'Group'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_HOME"      'Message' 'DatabaseHome' 'DescriptionDatabaseHome'
  local -i Retcode=$?
  local -r User
  local -r Group
  local -r DatabaseHome
  local -r DescriptionDatabaseHome
  local -r DatabaseDeinstaller="${DatabaseHome}/deinstall/deinstall"
  local -r DescriptionDatabaseDeinstaller="${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} de-installer program"
  local ResponseFileName=''
  local -r DescriptionResponseFileName="${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} de-installation response file"

  ###########################################################
  # Preparation for de-installation of the Oracle Database. #
  ###########################################################

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoSection "Preparation for de-installation of the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]}"
  fi

  ### Validate that the Oracle Database is installed in the provided home directory. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' 'test' '-d' "$DatabaseHome"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${DescriptionDatabaseHome} exists" "$DatabaseHome"
      Retcode=$?
    else
      echoCommandMessage "the ${DescriptionDatabaseHome} does not exit" "$DatabaseHome"
      return $RETCODE_SUCCESS
    fi
  fi

  ### Validate that the Oracle Database de-installer is present and usable by the installation user. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" -g "$Group" 'test' '-x' "$DatabaseDeinstaller"
    processCommandCode $? "the ${DescriptionDatabaseDeinstaller} does not exist or is inaccessible" "$DatabaseDeinstaller"
    Retcode=$?
  fi

  ### Export the CV_ASSUME_DISTID environment variable to enable de-installation of the Oracle databse. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    local -r CV_ASSUME_DISTID_VALUE='OL7'
    echoCommand 'export' "CV_ASSUME_DISTID=${CV_ASSUME_DISTID_VALUE}"
    export CV_ASSUME_DISTID="$CV_ASSUME_DISTID_VALUE"
    processCommandCode $? "failed to export the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} environment variable CV_ASSUME_DISTID" "$CV_ASSUME_DISTID_VALUE"
    Retcode=$?
  fi

  ### Generate the automated uninstallation response file. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    local Line=''
    local Left=''
    local Right=''
    echoCommand 'sudo' '-E' '-u' "$User" '-g' "$Group" "$DatabaseDeinstaller" '-silent' '-checkonly'
    while IFS= read -r Line ; do
      if [[ -z "$Right" ]] ; then
        Left=$(echo "$Line" | awk -F ':' '{ print $1 }')
        if [[ 'Location of response file generated' == "$Left" ]] ; then
          Right=$(echo "$Line" | awk -F ':' '{ print $2 }')
        else
          Left=''
        fi
      fi
    done < <(sudo -E -u "$User" -g "$Group" "$DatabaseDeinstaller" -silent -checkonly)
    Retcode=$?
    if [[ 0 -eq $Retcode ]] && [[ -n "$Right" ]] ; then
      ResponseFileName=$(echo "$Right" | awk -F "$CHARACTER_SINGLE_QUOTE" '{ print $2 }')
      if [[ -z "$ResponseFileName" ]] ; then
        echoError $RETCODE_OPERATION_ERROR "failed to obtain a ${DescriptionResponseFileName} from the ${DescriptionDatabaseDeinstaller}" "$DatabaseDeinstaller"
      else
        echoCommandMessage "${DescriptionResponseFileName}" "$ResponseFileName"
      fi
    else
      echoError $Retcode "failed to generate a ${DescriptionResponseFileName} with the ${DescriptionDatabaseDeinstaller}" "$DatabaseDeinstaller"
    fi
    Retcode=$?
  fi

  ### Validate that the automated uninstallation response file is present and accessible to the installation user. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-E' '-u' "$User" '-g' "$Group" 'test' '-r' "$ResponseFileName"
    processCommandCode $? "the ${DescriptionResponseFileName} does not exist or is inaccessible" "$ResponseFileName"
    Retcode=$?
  fi

  ###########################################
  # De-installation of the Oracle Database. #
  ###########################################

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoSection "De-installation of the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]}"
  fi

  ### Uninstall the Oracle Database software. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-E' '-u' "$User" '-g' "$Group" "$DatabaseDeinstaller" '-silent' '-paramfile' "$ResponseFileName"
    processCommandCode $? "an error occurred when running the ${DescriptionDatabaseDeinstaller}" "$DatabaseDeinstaller" "response file" "$ResponseFileName"
    Retcode=$?
  fi

  return $Retcode
}

################################################################################
## @fn uninstallManager
##
## @brief Uninstall the Oracle Enterprise Manager.
##
## @param[in] Sources The name of the variable that contains the sources of the
##                    program option values.
## @param[in] Values  The name of the vatiable that contains the program option
##                    values.
##
## @note This function performs the following steps:
##
## @li Copy of the Oracle Enterprise Manager deinstallation program to a
##     temporary direcrory.
## @li Deinstallation the Oracle Enterprise Mananger.
## @li Deletion of the Oracle Enterprise Manager deinstallation program.
##
## @return The return code of the function execution.
################################################################################
uninstallManager() {
  local Message=''
  local InstallationStage
  local User
  local Group
  local DatabasePassword
  local ManagerHome
  local DescriptionManagerHome
  local ManagerPassword
  local WeblogicPassword
  echoTitle "Uninstalling the ${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]}"
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_STAGE" 'Message' 'InstallationStage'
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_USER"  'Message' 'User'
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_GROUP" 'Message' 'Group'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_PASSWORD"  'Message' 'DatabasePassword'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_HOME"       'Message' 'ManagerHome' 'DescriptionManagerHome'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_PASSWORD"   'Message' 'ManagerPassword'
  retrieveOption $? "$1" "$2" "$OPTION_WEBLOGIC_PASSWORD"  'Message' 'WeblogicPassword'
  local -i Retcode=$?
  local -r InstallationStage
  local -r User
  local -r Group
  local -r DatabasePassword
  local -r ManagerHome
  local -r DescriptionManagerHome
  local -r ManagerPassword
  local -r WeblogicPassword
  local -r ManagerDeinstaller1="${ManagerHome}/sysman/install/EMDeinstall.pl"
  local -r ManagerDeinstaller2="${InstallationStage}/EMDeinstall.pl"
  local -r DescriptionDatabaseDeinstaller="${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} de-installer program"

  # Validate that the Oracle Enterprise Manager is installed in the provided home directory. #

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' 'test' '-d' "$ManagerHome"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${DescriptionManagerHome} exists" "$ManagerHome"
      Retcode=$?
    else
      echoCommandMessage "the ${DescriptionManagerHome} does not exist" "$ManagerHome"
      return $RETCODE_SUCCESS
    fi
  fi

  # Validate that the Oracle Enterprise Manager de-installer program is present. #

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-r' "$ManagerDeinstaller1"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${DescriptionDatabaseDeinstaller} exists" "$ManagerDeinstaller1"
      Retcode=$?
    else
      echoCommandMessage "the ${DescriptionDatabaseDeinstaller} does not exist or is inaccessible" "$ManagerDeinstaller1"
      return $RETCODE_SUCCESS
    fi
  fi

  # Copy the Oracle Enterprise Manager de-installer program to the staging location. #

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "${User}" '-g' "$Group" 'cp' "$ManagerDeinstaller1" "$ManagerDeinstaller2"
    processCommandCode $? "the ${DescriptionDatabaseDeinstaller} '${ManagerDeinstaller1}' was not copied to '${ManagerDeinstaller2}'"
    Retcode=$?
  fi

  # Uninstall the Oracle Enterprise Manager. #

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoCommand 'printf' "y\n${DatabasePassword}\n${ManagerPassword}\n${WeblogicPassword}\n" '|' 'sudo' 'su' '-' "$User" '-s' '/usr/bin/bash' '-c' "${ManagerHome}/perl/bin/perl" "$ManagerDeinstaller2" '-mwHome' "$ManagerHome" '-stageLoc' "$InstallationStage"
    printf "y\n${DatabasePassword}\n${ManagerPassword}\n${WeblogicPassword}\n" | sudo 'su' '-' "${User}" '-s' '/usr/bin/bash' '-c' "${ManagerHome}/perl/bin/perl ${ManagerDeinstaller2} -mwHome ${ManagerHome} -stageLoc ${InstallationStage}"
    processCommandCode $? "an error occurred when running the ${DescriptionDatabaseDeinstaller}" "$ManagerDeinstaller2"
    Retcode=$?
  fi

  # Delete the staged Oracle Enterprise Manager de-installer program. #

  executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-r' "$ManagerDeinstaller2"
  if [[ 0 -eq $? ]] ; then
    echoCommandMessage "the staged ${DescriptionDatabaseDeinstaller} exists" "$ManagerDeinstaller2"
  else
    echoCommandMessage "the staged ${DescriptionDatabaseDeinstaller} does not exist" "$ManagerDeinstaller2"
  fi
  local -r -i Retcode2=$?

  if [[ $RETCODE_SUCCESS -eq $Retcode2 ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'rm' '-f' "$ManagerDeinstaller2"
    processCommandCode $? "failed to delete the temporary ${DescriptionDatabaseDeinstaller}" "$ManagerDeinstaller2"
    local -r -i Retcode3=$?
    if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
      Retcode=$Retcode3
    fi
  fi

  return $Retcode
}

################
# Main program #
################

declare -A -i OptionSources=()
declare -A OptionValues=()
declare Message=''
declare -i Retcode=$RETCODE_SUCCESS

if [[ 1 -gt $# ]] ; then
  echoHelp $VALUE_FALSE
  exit $?
fi

# Process the command line options.

while [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ -n "$1" ]] && [[ "${1::${#OPTION_PREFIX}}" == "$OPTION_PREFIX" ]] ; do
  setOption $Retcode 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_COMMAND "${1%=*}" "${1#*=}"
  Retcode=$?
  shift
done

# Read the command.

if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
  if [[ 1 -le $# ]] ; then
    if [[ "$COMMAND_HELP" == "$1" ]] || \
       [[ "$COMMAND_OPTIONS" == "$1" ]] || \
       [[ "$COMMAND_PREPARE" == "$1" ]] || \
       [[ "$COMMAND_INSTALL" == "$1" ]] || \
       [[ "$COMMAND_UNINSTALL" == "$1" ]] ; then
      declare -r COMMAND="$1"
      shift
    else
      echoError $RETCODE_PARAMETER_ERROR 'Unknown command program' "$1"
      Retcode=$?
    fi
  fi
  if [[ 1 -le $# ]] ; then
    if [[ "$COMMAND_INSTALL" == "$COMMAND" ]] || [[ "$COMMAND_UNINSTALL" == "$COMMAND" ]] ; then
      if [[ "$PRODUCT_DATABASE" == "$1" ]] || [[ "$PRODUCT_MANAGER" == "$1" ]] || [[ "$PRODUCT_AGENT" == "$1" ]] ; then
        declare -r COMMAND_TARGET="$1"
        shift
      else
        echoError $RETCODE_PARAMETER_ERROR "Unknown target for command '${COMMAND}'" "$1"
        Retcode=$?
      fi
    fi
  fi
fi

if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
  if [[ 0 -ne $# ]] ; then
    echoError $RETCODE_PARAMETER_ERROR 'incorrect command paramaters'
    Retcode=$?
  elif [[ -z "${COMMAND_TARGET+'x'}" ]] ; then
    declare -r COMMAND_TARGET=''
  fi
fi

# Process the options file, if one was provided.

processOptionsFile $Retcode 'Message' 'OptionSources' 'OptionValues'

# Process the determined options.

setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_INSTALLATION_ROOT"            "${OPTION_DEFAULT_VALUES[${OPTION_INSTALLATION_ROOT}]}"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_INSTALLATION_USER"            "${OPTION_DEFAULT_VALUES[${OPTION_INSTALLATION_USER}]}"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_INSTALLATION_BASE"            "${OptionValues[${OPTION_INSTALLATION_ROOT}]}/${OptionValues[${OPTION_INSTALLATION_USER}]}"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_INSTALLATION_INVENTORY"       "${OptionValues[${OPTION_INSTALLATION_ROOT}]}/oraInventory"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_DATABASE_VERSION"             "${OPTION_DEFAULT_VALUES[${OPTION_DATABASE_VERSION}]}"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_DATABASE_NAME"                "${OPTION_DEFAULT_VALUES[${OPTION_DATABASE_NAME}]}"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_DATABASE_BASE"                "${OptionValues[${OPTION_INSTALLATION_BASE}]}/${PRODUCT_DATABASE}"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_DATABASE_HOME"                "${OptionValues[${OPTION_DATABASE_BASE}]}/product/${OptionValues[${OPTION_DATABASE_VERSION}]}"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_DATABASE_DATA"                "${OptionValues[${OPTION_DATABASE_BASE}]}/oradata/${OptionValues[${OPTION_DATABASE_NAME}]}"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_DATABASE_RECOVERY"            "${OptionValues[${OPTION_DATABASE_BASE}]}/recovery/${OptionValues[${OPTION_DATABASE_NAME}]}"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_MANAGER_VERSION"              "${OPTION_DEFAULT_VALUES[${OPTION_MANAGER_VERSION}]}"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_MANAGER_BASE"                 "${OptionValues[${OPTION_INSTALLATION_BASE}]}/${PRODUCT_MANAGER}"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_MANAGER_HOME"                 "${OptionValues[${OPTION_MANAGER_BASE}]}/product/${OptionValues[${OPTION_MANAGER_VERSION}]}"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_MANAGER_INSTANCE"             "${OptionValues[${OPTION_MANAGER_BASE}]}/gc_inst"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_MANAGER_KEYSTORE_FILE_NAME"   "${OptionValues[${OPTION_MANAGER_BASE}]}/oradata/ewallet-keystore.p12"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_MANAGER_TRUSTSTORE_FILE_NAME" "${OptionValues[${OPTION_MANAGER_BASE}]}/oradata/ewallet-truststore.p12"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_AGENT_BASE"                   "${OptionValues[${OPTION_INSTALLATION_BASE}]}/${PRODUCT_AGENT}"
Retcode=$?

# Set all remaining options to their default values.

declare Option=''
for Option in "${!OPTION_DEFAULT_VALUES[@]}" ; do
  setOption $Retcode 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$Option" "${OPTION_DEFAULT_VALUES[${Option}]}"
  Retcode=$?
done
unset Option

#if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
#  for Option in "${OPTIONS[@]}" ; do
#    echo "${Option}: ${OptionValues[${Option}]} (${OPTION_SOURCE_NAMES[${OptionSources[${Option}]}]})"
#  done
#fi

if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
  case "$COMMAND" in
    "$COMMAND_HELP")
      echoHelp $VALUE_TRUE
      Retcode=$?
      ;;
    "$COMMAND_OPTIONS")
      displayOptions 'OptionSources' 'OptionValues'
      Retcode=$?
      ;;
    "$COMMAND_PREPARE"|"$COMMAND_INSTALL")
      displayOptions 'OptionSources' 'OptionValues'
      Retcode=$?
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        prepareInstallation 'OptionSources' 'OptionValues'
        Retcode=$?
      fi
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ "$COMMAND_INSTALL" == "$COMMAND" ]]; then
        if [[ -z "$COMMAND_TARGET" ]] || [[ "$PRODUCT_DATABASE" == "$COMMAND_TARGET" ]] ; then
          installDatabase 'OptionSources' 'OptionValues'
          Retcode=$?
        fi
      fi
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ "$COMMAND_INSTALL" == "$COMMAND" ]]; then
        if [[ -z "$COMMAND_TARGET" ]] || [[ "$PRODUCT_MANAGER" == "$COMMAND_TARGET" ]] ; then
          installManager 'OptionSources' 'OptionValues'
          Retcode=$?
        fi
      fi
      ;;
    "$COMMAND_UNINSTALL")
      displayOptions 'OptionSources' 'OptionValues'
      Retcode=$?
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        if [[ -z "$COMMAND_TARGET" ]] || [[ "$PRODUCT_MANAGER" == "$COMMAND_TARGET" ]] ; then
          uninstallManager 'OptionSources' 'OptionValues'
          Retcode=$?
        fi
      fi
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        if [[ -z "$COMMAND_TARGET" ]] || [[ "$PRODUCT_DATABASE" == "$COMMAND_TARGET" ]] ; then
          uninstallDatabase 'OptionSources' 'OptionValues'
          Retcode=$?
        fi
      fi
      ;;
    *)
      echoError $RETCODE_INTERNAL_ERROR 'command not yet implemented or supported' "$COMMAND"
      Retcode=$?
      ;;
  esac
else
  echo "$Message"
fi

case "$COMMAND" in
  "$COMMAND_PREPARE")
    if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
      echo 'System preparation successful'
    else
      echo "System preparation failed: ${Retcode}"
    fi
    ;;
  "$COMMAND_INSTALL")
    if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
      echo 'Installation successful'
      if [[ -z "$COMMAND_TARGET" ]] || [[ "$PRODUCT_DATABASE" == "$COMMAND_TARGET" ]] ; then
        echo "Environment variables for the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]}"
        echo "ORACLE_BASE=${OptionValues[${OPTION_DATABASE_BASE}]}"
        echo "ORACLE_HOME=${OptionValues[${OPTION_DATABASE_HOME}]}"
      fi
      if [[ -z "$COMMAND_TARGET" ]] || [[ "$PRODUCT_MANAGER" == "$COMMAND_TARGET" ]] ; then
        echo "Environment variables for the ${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]}"
        echo "ORACLE_BASE=${OptionValues[${OPTION_MANAGER_BASE}]}"
        echo "ORACLE_HOME=${OptionValues[${OPTION_MANAGER_HOME}]}"
      fi
    else
      echo "Installation failed: ${Retcode}"
    fi
    ;;
  "$COMMAND_UNINSTALL")
    if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
      echo 'Uninstallation successful'
    else
      echo "Uninstallation failed: ${Retcode}"
    fi
    ;;
  *)
    ;;
esac

exit $Retcode
