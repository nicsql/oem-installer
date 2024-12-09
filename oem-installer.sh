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
declare -r PRODUCT_ALL='all'
declare -r -a PRODUCTS=(
  "$PRODUCT_DATABASE"
  "$PRODUCT_MANAGER"
  "$PRODUCT_AGENT"
  "$PRODUCT_ALL"
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
  ["$PRODUCT_ALL"]='Oracle Database and Enterprise Manager'
)

####################
# Program commands #
####################

declare -r COMMAND_HELP='help'
declare -r COMMAND_OPTIONS='options'
declare -r COMMAND_PREPARE='prepare'
declare -r COMMAND_PROVISION='provision'
declare -r COMMAND_INSTALL='install'
declare -r COMMAND_UNINSTALL='uninstall'
declare -r -a COMMANDS=(
  "$COMMAND_HELP"
  "$COMMAND_OPTIONS"
  "$COMMAND_PREPARE"
  "$COMMAND_PROVISION"
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
  ["$COMMAND_PROVISION"]='prepare the system and provision (extract) the Oracle products for installation'
  ["$COMMAND_INSTALL"]="prepare the system, and provision and install the Oracle products"
  ["$COMMAND_UNINSTALL"]="uninstall the Oracle products"
)

###################
# Program options #
###################

declare -r OPTION_PREFIX='--'
declare -r OPTION_UNKNOWN='Unknown'
declare -r OPTION_FILE_NAME='options-file-name'
declare -r OPTION_STAGING_DIRECTORY_NAME='stage'
declare -r OPTION_PATCHES_DIRECTORY_NAME='stage-patches'
declare -r OPTION_INSTALLATION_ROOT_DIRECTORY_NAME='installation-root'
declare -r OPTION_INSTALLATION_INVENTORY_DIRECTORY_NAME='installation-inventory'
declare -r OPTION_INSTALLATION_BASE_DIRECTORY_NAME='installation-base'
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
declare -r OPTION_DATABASE_BASE_DIRECTORY_NAME='database-base'
declare -r OPTION_DATABASE_HOME_DIRECTORY_NAME='database-home'
declare -r OPTION_DATABASE_DATA_DIRECTORY_NAME='database-data'
declare -r OPTION_DATABASE_RECOVERY_DIRECTORY_NAME='database-recovery'
declare -r OPTION_DATABASE_NAME='database-name'
declare -r OPTION_DATABASE_HOSTNAME='database-hostname'
declare -r OPTION_DATABASE_PORT='database-port'
declare -r OPTION_DATABASE_ADMINISTRATOR_GROUP_NAME='dba-group'
declare -r OPTION_DATABASE_PASSWORD='database-password'
declare -r OPTION_MANAGER_VERSION='manager-version'
declare -r OPTION_MANAGER_PACKAGES_FILE_NAMES='manager-packages-file-names'
declare -r OPTION_MANAGER_OPATCH_FILE_NAME='manager-opatch-file-name'
declare -r OPTION_MANAGER_OMSPATCHER_FILE_NAME='manager-omspatcher-file-name'
declare -r OPTION_MANAGER_UPGRADE_PATCH_FILE_NAME='manager-upgrade-patch-file-name'
declare -r OPTION_MANAGER_PATCHES_FILE_NAMES='manager-patches-file-names'
declare -r OPTION_MANAGER_RESPONSE_FILE_NAME='manager-response-file-name'
declare -r OPTION_MANAGER_RESPONSE_FILE_PERMISSIONS='manager-response-file-permissions'
declare -r OPTION_MANAGER_BASE_DIRECTORY_NAME='manager-base'
declare -r OPTION_MANAGER_HOME_DIRECTORY_NAME='manager-home'
declare -r OPTION_MANAGER_INSTANCE_DIRECTORY_NAME='manager-instance'
declare -r OPTION_MANAGER_USER_PORT='manager-user-port'
declare -r OPTION_MANAGER_UPLOAD_PORT='manager-upload-port'
declare -r OPTION_MANAGER_PASSWORD='manager-password'
declare -r OPTION_MANAGER_KEYSTORE_FILE_NAME='keystore-file'
declare -r OPTION_MANAGER_KEYSTORE_PASSWORD='keystore-password'
declare -r OPTION_MANAGER_TRUSTSTORE_FILE_NAME='truststore-file'
declare -r OPTION_MANAGER_TRUSTSTORE_PASSWORD='truststore-password'
declare -r OPTION_AGENT_BASE_DIRECTORY_NAME='agent-base'
declare -r OPTION_AGENT_HOME_DIRECTORY_NAME='agent-home'
declare -r OPTION_AGENT_INSTANCE_DIRECTORY_NAME='agent-instance'
declare -r OPTION_AGENT_PORT='agent-port'
declare -r OPTION_AGENT_PASSWORD='agent-password'
declare -r OPTION_WEBLOGIC_PORT='weblogic-port'
declare -r OPTION_WEBLOGIC_USER='weblogic-user'
declare -r OPTION_WEBLOGIC_PASSWORD='weblogic-password'
declare -r OPTION_SUDOERS_FILE_NAME='sudoers-file-name'
declare -r OPTION_SUDOERS_FILE_PERMISSIONS='sudoers-file-permissions'
declare -r OPTION_SWAP_GOAL='swap-goal'
declare -r OPTION_SWAP_FILE_NAME='swap-file-name'
declare -r OPTION_SWAP_FILE_PERMISSIONS='swap-file-permissions'
declare -r OPTION_SYSCTL_FILE_NAME='sysctl-file-name'
declare -r OPTION_SYSCTL_FILE_PERMISSIONS='sysctl-file-permissions'
declare -r OPTION_LIMITS_DATABASE_FILE_NAME='database-limits-file-name'
declare -r OPTION_LIMITS_MANAGER_FILE_NAME='manager-limits-file-name'
declare -r OPTION_LIMITS_FILE_PERMISSIONS='limits-file-permissions'
declare -r OPTION_CONTROLLER_FILE_NAME='controller-file-name'
declare -r OPTION_CONTROLLER_FILE_PERMISSIONS='controller-file-permissions'
declare -r OPTION_SYSTEMD_SERVICE_NAME='systemd-service'
declare -r OPTION_SYSTEMD_FILE_NAME='systemd-file-name'
declare -r OPTION_SYSTEMD_FILE_PERMISSIONS='systemd-file-permissions'

# Option display sorted order

declare -r -a OPTIONS=(
  "$OPTION_FILE_NAME"
  "$OPTION_STAGING_DIRECTORY_NAME"
  "$OPTION_PATCHES_DIRECTORY_NAME"
  "$OPTION_INSTALLATION_ROOT_DIRECTORY_NAME"
  "$OPTION_INSTALLATION_INVENTORY_DIRECTORY_NAME"
  "$OPTION_INSTALLATION_BASE_DIRECTORY_NAME"
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
  "$OPTION_DATABASE_BASE_DIRECTORY_NAME"
  "$OPTION_DATABASE_HOME_DIRECTORY_NAME"
  "$OPTION_DATABASE_DATA_DIRECTORY_NAME"
  "$OPTION_DATABASE_RECOVERY_DIRECTORY_NAME"
  "$OPTION_DATABASE_NAME"
  "$OPTION_DATABASE_HOSTNAME"
  "$OPTION_DATABASE_PORT"
  "$OPTION_DATABASE_ADMINISTRATOR_GROUP_NAME"
  "$OPTION_DATABASE_PASSWORD"
  "$OPTION_MANAGER_VERSION"
  "$OPTION_MANAGER_PACKAGES_FILE_NAMES"
  "$OPTION_MANAGER_OPATCH_FILE_NAME"
  "$OPTION_MANAGER_OMSPATCHER_FILE_NAME"
  "$OPTION_MANAGER_RESPONSE_FILE_NAME"
  "$OPTION_MANAGER_RESPONSE_FILE_PERMISSIONS"
  "$OPTION_MANAGER_BASE_DIRECTORY_NAME"
  "$OPTION_MANAGER_HOME_DIRECTORY_NAME"
  "$OPTION_MANAGER_INSTANCE_DIRECTORY_NAME"
  "$OPTION_MANAGER_USER_PORT"
  "$OPTION_MANAGER_UPLOAD_PORT"
  "$OPTION_MANAGER_PASSWORD"
  "$OPTION_MANAGER_KEYSTORE_FILE_NAME"
  "$OPTION_MANAGER_KEYSTORE_PASSWORD"
  "$OPTION_MANAGER_TRUSTSTORE_FILE_NAME"
  "$OPTION_MANAGER_TRUSTSTORE_PASSWORD"
  "$OPTION_AGENT_BASE_DIRECTORY_NAME"
  "$OPTION_AGENT_HOME_DIRECTORY_NAME"
  "$OPTION_AGENT_INSTANCE_DIRECTORY_NAME"
  "$OPTION_AGENT_PORT"
  "$OPTION_AGENT_PASSWORD"
  "$OPTION_WEBLOGIC_PORT"
  "$OPTION_WEBLOGIC_USER"
  "$OPTION_WEBLOGIC_PASSWORD"
  "$OPTION_SUDOERS_FILE_NAME"
  "$OPTION_SUDOERS_FILE_PERMISSIONS"
  "$OPTION_SWAP_GOAL"
  "$OPTION_SWAP_FILE_NAME"
  "$OPTION_SWAP_FILE_PERMISSIONS"
  "$OPTION_SYSCTL_FILE_NAME"
  "$OPTION_SYSCTL_FILE_PERMISSIONS"
  "$OPTION_LIMITS_DATABASE_FILE_NAME"
  "$OPTION_LIMITS_MANAGER_FILE_NAME"
  "$OPTION_LIMITS_FILE_PERMISSIONS"
  "$OPTION_CONTROLLER_FILE_NAME"
  "$OPTION_CONTROLLER_FILE_PERMISSIONS"
  "$OPTION_SYSTEMD_SERVICE_NAME"
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
  ["$OPTION_STAGING_DIRECTORY_NAME"]=$OPTION_SOURCE_ALL
  ["$OPTION_PATCHES_DIRECTORY_NAME"]=$OPTION_SOURCE_PROGRAM
  ["$OPTION_INSTALLATION_ROOT_DIRECTORY_NAME"]=$OPTION_SOURCE_ALL
  ["$OPTION_INSTALLATION_INVENTORY_DIRECTORY_NAME"]=$OPTION_SOURCE_ALL
  ["$OPTION_INSTALLATION_BASE_DIRECTORY_NAME"]=$OPTION_SOURCE_ALL
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
  ["$OPTION_DATABASE_BASE_DIRECTORY_NAME"]=$OPTION_SOURCE_ALL
  ["$OPTION_DATABASE_HOME_DIRECTORY_NAME"]=$OPTION_SOURCE_ALL
  ["$OPTION_DATABASE_DATA_DIRECTORY_NAME"]=$OPTION_SOURCE_ALL
  ["$OPTION_DATABASE_RECOVERY_DIRECTORY_NAME"]=$OPTION_SOURCE_ALL
  ["$OPTION_DATABASE_NAME"]=$OPTION_SOURCE_ALL
  ["$OPTION_DATABASE_HOSTNAME"]=$OPTION_SOURCE_ALL
  ["$OPTION_DATABASE_PORT"]=$OPTION_SOURCE_ALL
  ["$OPTION_DATABASE_ADMINISTRATOR_GROUP_NAME"]=$OPTION_SOURCE_ALL
  ["$OPTION_DATABASE_PASSWORD"]=$OPTION_SOURCE_ALL
  ["$OPTION_MANAGER_VERSION"]=$OPTION_SOURCE_ALL
  ["$OPTION_MANAGER_PACKAGES_FILE_NAMES"]=$OPTION_SOURCE_ALL
  ["$OPTION_MANAGER_OPATCH_FILE_NAME"]=$OPTION_SOURCE_ALL
  ["$OPTION_MANAGER_OMSPATCHER_FILE_NAME"]=$OPTION_SOURCE_ALL
  ["$OPTION_MANAGER_UPGRADE_PATCH_FILE_NAME"]=$OPTION_SOURCE_ALL
  ["$OPTION_MANAGER_PATCHES_FILE_NAMES"]=$OPTION_SOURCE_ALL
  ["$OPTION_MANAGER_RESPONSE_FILE_NAME"]=$OPTION_SOURCE_ALL
  ["$OPTION_MANAGER_RESPONSE_FILE_PERMISSIONS"]=$OPTION_SOURCE_PROGRAM
  ["$OPTION_MANAGER_BASE_DIRECTORY_NAME"]=$OPTION_SOURCE_ALL
  ["$OPTION_MANAGER_HOME_DIRECTORY_NAME"]=$OPTION_SOURCE_ALL
  ["$OPTION_MANAGER_INSTANCE_DIRECTORY_NAME"]=$OPTION_SOURCE_ALL
  ["$OPTION_MANAGER_USER_PORT"]=$OPTION_SOURCE_ALL
  ["$OPTION_MANAGER_UPLOAD_PORT"]=$OPTION_SOURCE_ALL
  ["$OPTION_MANAGER_PASSWORD"]=$OPTION_SOURCE_FILE
  ["$OPTION_MANAGER_KEYSTORE_FILE_NAME"]=$OPTION_SOURCE_ALL
  ["$OPTION_MANAGER_KEYSTORE_PASSWORD"]=$OPTION_SOURCE_FILE
  ["$OPTION_MANAGER_TRUSTSTORE_FILE_NAME"]=$OPTION_SOURCE_ALL
  ["$OPTION_MANAGER_TRUSTSTORE_PASSWORD"]=$OPTION_SOURCE_FILE
  ["$OPTION_AGENT_BASE_DIRECTORY_NAME"]=$OPTION_SOURCE_ALL
  ["$OPTION_AGENT_HOME_DIRECTORY_NAME"]=$OPTION_SOURCE_PROGRAM
  ["$OPTION_AGENT_INSTANCE_DIRECTORY_NAME"]=$OPTION_SOURCE_PROGRAM
  ["$OPTION_AGENT_PORT"]=$OPTION_SOURCE_ALL
  ["$OPTION_AGENT_PASSWORD"]=$OPTION_SOURCE_FILE
  ["$OPTION_WEBLOGIC_PORT"]=$OPTION_SOURCE_ALL
  ["$OPTION_WEBLOGIC_USER"]=$OPTION_SOURCE_ALL
  ["$OPTION_WEBLOGIC_PASSWORD"]=$OPTION_SOURCE_FILE
  ["$OPTION_SUDOERS_FILE_NAME"]=$OPTION_SOURCE_PROGRAM
  ["$OPTION_SUDOERS_FILE_PERMISSIONS"]=$OPTION_SOURCE_PROGRAM
  ["$OPTION_SWAP_GOAL"]=$OPTION_SOURCE_ALL
  ["$OPTION_SWAP_FILE_NAME"]=$OPTION_SOURCE_ALL
  ["$OPTION_SWAP_FILE_PERMISSIONS"]=$OPTION_SOURCE_PROGRAM
  ["$OPTION_SYSCTL_FILE_NAME"]=$OPTION_SOURCE_PROGRAM
  ["$OPTION_SYSCTL_FILE_PERMISSIONS"]=$OPTION_SOURCE_PROGRAM
  ["$OPTION_LIMITS_DATABASE_FILE_NAME"]=$OPTION_SOURCE_PROGRAM
  ["$OPTION_LIMITS_MANAGER_FILE_NAME"]=$OPTION_SOURCE_PROGRAM
  ["$OPTION_LIMITS_FILE_PERMISSIONS"]=$OPTION_SOURCE_PROGRAM
  ["$OPTION_CONTROLLER_FILE_NAME"]=$OPTION_SOURCE_ALL
  ["$OPTION_CONTROLLER_FILE_PERMISSIONS"]=$OPTION_SOURCE_PROGRAM
  ["$OPTION_SYSTEMD_SERVICE_NAME"]=$OPTION_SOURCE_ALL
  ["$OPTION_SYSTEMD_FILE_NAME"]=$OPTION_SOURCE_PROGRAM
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

declare -r DEFAULT_SYSTEMD_SERVICE_NAME='oracle.service'
declare -r DEFAULT_PASSWORD='Abcd_1234'

declare -r -A OPTION_DEFAULT_VALUES=(
  ["$OPTION_INSTALLATION_ROOT_DIRECTORY_NAME"]='/u01/app'
  ["$OPTION_INSTALLATION_FILE_PERMISSIONS"]='755'
  ["$OPTION_INSTALLATION_USER"]='oracle'
  ["$OPTION_INSTALLATION_GROUP"]='oinstall'
  ["$OPTION_INSTALLATION_HOSTNAME"]=`hostname -f`
  ["$OPTION_DATABASE_VERSION"]='19.3.0.0.0'
  ["$OPTION_DATABASE_RESPONSE_FILE_NAME"]='/tmp/db_install.rsp'
  ["$OPTION_DATABASE_RESPONSE_FILE_PERMISSIONS"]='640'
  ["$OPTION_DATABASE_NAME"]='emrep'
  ["$OPTION_DATABASE_HOSTNAME"]=`hostname -f`
  ["$OPTION_DATABASE_PORT"]='1521'
  ["$OPTION_DATABASE_ADMINISTRATOR_GROUP_NAME"]='dba'
  ["$OPTION_DATABASE_PASSWORD"]="$DEFAULT_PASSWORD"
  ["$OPTION_MANAGER_VERSION"]='13.5.0.0.0'
  ["$OPTION_MANAGER_RESPONSE_FILE_NAME"]='/tmp/em_install.rsp'
  ["$OPTION_MANAGER_RESPONSE_FILE_PERMISSIONS"]='640'
  ["$OPTION_MANAGER_USER_PORT"]='7803'
  ["$OPTION_MANAGER_UPLOAD_PORT"]='4903'
  ["$OPTION_MANAGER_PASSWORD"]="$DEFAULT_PASSWORD"
  ["$OPTION_MANAGER_KEYSTORE_PASSWORD"]="$DEFAULT_PASSWORD"
  ["$OPTION_MANAGER_TRUSTSTORE_PASSWORD"]="$DEFAULT_PASSWORD"
  ["$OPTION_AGENT_PORT"]='3872'
  ["$OPTION_AGENT_PASSWORD"]="$DEFAULT_PASSWORD"
  ["$OPTION_WEBLOGIC_PORT"]='7102'
  ["$OPTION_WEBLOGIC_USER"]='weblogic'
  ["$OPTION_WEBLOGIC_PASSWORD"]="$DEFAULT_PASSWORD"
  ["$OPTION_SUDOERS_FILE_NAME"]='/etc/sudoers.d/101-oracle-user'
  ["$OPTION_SUDOERS_FILE_PERMISSIONS"]='440'
  ["$OPTION_SWAP_GOAL"]=16
  ["$OPTION_SWAP_FILE_NAME"]='/.swapfile_oem'
  ["$OPTION_SWAP_FILE_PERMISSIONS"]='600'
  ["$OPTION_SYSCTL_FILE_NAME"]='/etc/sysctl.d/99-oracle-database-preinstall-19c-sysctl.conf'
  ["$OPTION_SYSCTL_FILE_PERMISSIONS"]='644'
  ["$OPTION_LIMITS_DATABASE_FILE_NAME"]='/etc/security/limits.d/oracle-database-preinstall-19c.conf'
  ["$OPTION_LIMITS_MANAGER_FILE_NAME"]='/etc/security/limits.d/oracle-em.conf'
  ["$OPTION_LIMITS_FILE_PERMISSIONS"]='644'
  ["$OPTION_CONTROLLER_FILE_NAME"]='servicectl.sh'
  ["$OPTION_CONTROLLER_FILE_PERMISSIONS"]='740'
  ["$OPTION_SYSTEMD_SERVICE_NAME"]="$DEFAULT_SYSTEMD_SERVICE_NAME"
  ["$OPTION_SYSTEMD_FILE_NAME"]="/lib/systemd/system/${DEFAULT_SYSTEMD_SERVICE_NAME}"
  ["$OPTION_SYSTEMD_FILE_PERMISSIONS"]='644'
)

# Option descriptions

declare -r DESCRIPTION_STAGING_DIRECTORY='installation staging directory'
declare -r DESCRIPTION_PATCHES_DIRECTORY='staging directory for product patches'
declare -r DESCRIPTION_INSTALLATION_ROOT_DIRECTORY='Oracle installation root directory'
declare -r DESCRIPTION_INSTALLATION_INVENTORY_DIRECTORY='Oracle central inventory directory'
declare -r DESCRIPTION_INSTALLATION_BASE_DIRECTORY='Oracle installation base directory'
declare -r DESCRIPTION_DATABASE_PACKAGE_FILE="${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} software package zip file"
declare -r DESCRIPTION_DATABASE_OPATCH="${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} OPatch utility"
declare -r DESCRIPTION_DATABASE_OPATCH_HOME="home of the ${DESCRIPTION_DATABASE_OPATCH}"
declare -r DESCRIPTION_DATABASE_OPATCH_FILE="${DESCRIPTION_DATABASE_OPATCH} update zip file"
declare -r DESCRIPTION_DATABASE_UPGRADE_PATCH="${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} version patch update"
declare -r DESCRIPTION_DATABASE_UPGRADE_PATCH_FILE="${DESCRIPTION_DATABASE_UPGRADE_PATCH} zip file"
declare -r DESCRIPTION_DATABASE_RESPONSE_FILE="${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} installation response file"
declare -r DESCRIPTION_DATABASE_BASE_DIRECTORY="${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} base directory"
declare -r DESCRIPTION_DATABASE_HOME_DIRECTORY="${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} home directory"
declare -r DESCRIPTION_DATABASE_DATA_DIRECTORY="${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} data directory"
declare -r DESCRIPTION_DATABASE_RECOVERY_DIRECTORY="${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} recovery directory"
declare -r DESCRIPTION_DATABASE_ADMINISTRATOR_GROUP="${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} administrator system group"
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
declare -r DESCRIPTION_MANAGER_BASE_DIRECTORY="${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} base directory"
declare -r DESCRIPTION_MANAGER_HOME_DIRECTORY="${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} home directory"
declare -r DESCRIPTION_MANAGER_INSTANCE_DIRECTORY="${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} instance directory"
declare -r DESCRIPTION_MANAGER_KEYSTORE="${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} key store"
declare -r DESCRIPTION_MANAGER_KEYSTORE_FILE="${DESCRIPTION_MANAGER_KEYSTORE} file"
declare -r DESCRIPTION_MANAGER_TRUSTSTORE="${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} trust store"
declare -r DESCRIPTION_MANAGER_TRUSTSTORE_FILE="${DESCRIPTION_MANAGER_TRUSTSTORE} file"
declare -r DESCRIPTION_AGENT_BASE_DIRECTORY="${PRODUCT_DESCRIPTIONS[${PRODUCT_AGENT}]} base directory"
declare -r DESCRIPTION_AGENT_HOME_DIRECTORY="${PRODUCT_DESCRIPTIONS[${PRODUCT_AGENT}]} home directory"
declare -r DESCRIPTION_AGENT_INSTANCE_DIRECTORY="${PRODUCT_DESCRIPTIONS[${PRODUCT_AGENT}]} instance directory"
declare -r DESCRIPTION_SUDOERS_FILE='installation system user sudoers definition file'
declare -r DESCRIPTION_SWAP='system swap'
declare -r DESCRIPTION_SWAP_FILE="additional file for the ${DESCRIPTION_SWAP}"
declare -r DESCRIPTION_SYSCTL="Systemctl settings for the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]}"
declare -r DESCRIPTION_SYSCTL_FILE="definition file for the ${DESCRIPTION_SYSCTL}"
declare -r DESCRIPTION_LIMITS_DATABASE="system limits settings for the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]}"
declare -r DESCRIPTION_LIMITS_DATABASE_FILE="definition file for the ${DESCRIPTION_LIMITS_DATABASE}"
declare -r DESCRIPTION_LIMITS_MANAGER="system limits settings for the ${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]}"
declare -r DESCRIPTION_LIMITS_MANAGER_FILE="definition file for the ${DESCRIPTION_LIMITS_MANAGER}"
declare -r DESCRIPTION_CONTROLLER='service controller for the Oracle products'
declare -r DESCRIPTION_CONTROLLER_FILE="program file for ${DESCRIPTION_CONTROLLER}"
declare -r DESCRIPTION_SYSTEMD_SERVICE='Systemd service for the Oracle products'
declare -r DESCRIPTION_SYSTEMD_SERVICE_FILE="definition file for the ${DESCRIPTION_SYSTEMD_SERVICE}"

declare -r -A OPTION_DESCRIPTIONS=(
  ["$OPTION_FILE_NAME"]='name of an optional file that contains options to override the default option values of this program'
  ["$OPTION_STAGING_DIRECTORY_NAME"]="name of the ${DESCRIPTION_STAGING_DIRECTORY}"
  ["$OPTION_PATCHES_DIRECTORY_NAME"]="name of the ${DESCRIPTION_PATCHES_DIRECTORY}"
  ["$OPTION_INSTALLATION_ROOT_DIRECTORY_NAME"]="name of the ${DESCRIPTION_INSTALLATION_ROOT_DIRECTORY}"
  ["$OPTION_INSTALLATION_INVENTORY_DIRECTORY_NAME"]="name of the ${DESCRIPTION_INSTALLATION_INVENTORY_DIRECTORY}"
  ["$OPTION_INSTALLATION_BASE_DIRECTORY_NAME"]="name of the ${DESCRIPTION_INSTALLATION_BASE_DIRECTORY}"
  ["$OPTION_INSTALLATION_FILE_PERMISSIONS"]='file permissions of the Oracle installation'
  ["$OPTION_INSTALLATION_USER"]='installation system user'
  ["$OPTION_INSTALLATION_GROUP"]='installation system group'
  ["$OPTION_INSTALLATION_HOSTNAME"]='host name of this computer'
  ["$OPTION_DATABASE_VERSION"]="${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} version"
  ["$OPTION_DATABASE_PACKAGE_FILE_NAME"]="name of the ${DESCRIPTION_DATABASE_PACKAGE_FILE}"
  ["$OPTION_DATABASE_OPATCH_FILE_NAME"]="name of the ${DESCRIPTION_DATABASE_OPATCH_FILE}"
  ["$OPTION_DATABASE_UPGRADE_PATCH_FILE_NAME"]="name of the ${DESCRIPTION_DATABASE_UPGRADE_PATCH_FILE}"
  ["$OPTION_DATABASE_RESPONSE_FILE_NAME"]="name of the ${DESCRIPTION_DATABASE_RESPONSE_FILE}"
  ["$OPTION_DATABASE_RESPONSE_FILE_PERMISSIONS"]="file permissions on the ${DESCRIPTION_DATABASE_RESPONSE_FILE}"
  ["$OPTION_DATABASE_BASE_DIRECTORY_NAME"]="name of the ${DESCRIPTION_DATABASE_BASE_DIRECTORY}"
  ["$OPTION_DATABASE_HOME_DIRECTORY_NAME"]="name of the ${DESCRIPTION_DATABASE_HOME_DIRECTORY}"
  ["$OPTION_DATABASE_DATA_DIRECTORY_NAME"]="name of the ${DESCRIPTION_DATABASE_DATA_DIRECTORY}"
  ["$OPTION_DATABASE_RECOVERY_DIRECTORY_NAME"]="name of the ${DESCRIPTION_DATABASE_RECOVERY_DIRECTORY}"
  ["$OPTION_DATABASE_NAME"]="${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} name"
  ["$OPTION_DATABASE_HOSTNAME"]="host name of the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} listener"
  ["$OPTION_DATABASE_PORT"]="${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} listener network port"
  ["$OPTION_DATABASE_ADMINISTRATOR_GROUP_NAME"]="name of the ${DESCRIPTION_DATABASE_ADMINISTRATOR_GROUP}"
  ["$OPTION_DATABASE_PASSWORD"]="${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} sys account password"
  ["$OPTION_MANAGER_VERSION"]="${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} version"
  ["$OPTION_MANAGER_PACKAGES_FILE_NAMES"]="names of the ${DESCRIPTION_MANAGER_FILES}"
  ["$OPTION_MANAGER_OPATCH_FILE_NAME"]="names of the ${DESCRIPTION_MANAGER_OPATCH_FILE}"
  ["$OPTION_MANAGER_OMSPATCHER_FILE_NAME"]="names of the ${DESCRIPTION_MANAGER_OMSPATCHER_FILE}"
  ["$OPTION_MANAGER_UPGRADE_PATCH_FILE_NAME"]="name of the ${DESCRIPTION_NAME_UPGRADE_PATCH_FILE}"
  ["$OPTION_MANAGER_PATCHES_FILE_NAMES"]="names of the ${DESCRIPTION_MANAGER_PATCH_FILES}"
  ["$OPTION_MANAGER_RESPONSE_FILE_NAME"]="name of the ${DESCRIPTION_MANAGER_RESPONSE_FILE}"
  ["$OPTION_MANAGER_RESPONSE_FILE_PERMISSIONS"]="file permissions on the ${DESCRIPTION_MANAGER_RESPONSE_FILE}"
  ["$OPTION_MANAGER_BASE_DIRECTORY_NAME"]="name of the ${DESCRIPTION_MANAGER_BASE_DIRECTORY}"
  ["$OPTION_MANAGER_HOME_DIRECTORY_NAME"]="name of the ${DESCRIPTION_MANAGER_HOME_DIRECTORY}"
  ["$OPTION_MANAGER_INSTANCE_DIRECTORY_NAME"]="name of the ${DESCRIPTION_MANAGER_INSTANCE_DIRECTORY}"
  ["$OPTION_MANAGER_USER_PORT"]="${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} port"
  ["$OPTION_MANAGER_UPLOAD_PORT"]="${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} upload port"
  ["$OPTION_MANAGER_PASSWORD"]="${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} sysman account password"
  ["$OPTION_MANAGER_KEYSTORE_FILE_NAME"]="name of the ${OPTION_MANAGER_KEYSTORE_FILE}"
  ["$OPTION_MANAGER_KEYSTORE_PASSWORD"]="password for the ${OPTION_MANAGER_KEYSTORE_FILE}"
  ["$OPTION_MANAGER_TRUSTSTORE_FILE_NAME"]="name of the ${OPTION_MANAGER_TRUSTSTORE_FILE}"
  ["$OPTION_MANAGER_TRUSTSTORE_PASSWORD"]="password for the ${OPTION_MANAGER_TRUSTSTORE_FILE}"
  ["$OPTION_AGENT_BASE_DIRECTORY_NAME"]="name of the ${DESCRIPTION_AGENT_BASE_DIRECTORY}"
  ["$OPTION_AGENT_HOME_DIRECTORY_NAME"]="name of the ${DESCRIPTION_AGENT_HOME_DIRECTORY}"
  ["$OPTION_AGENT_INSTANCE_DIRECTORY_NAME"]="name of the ${DESCRIPTION_AGENT_INSTANCE_DIRECTORY}"
  ["$OPTION_AGENT_PORT"]="${PRODUCT_DESCRIPTIONS[${PRODUCT_AGENT}]} port"
  ["$OPTION_AGENT_PASSWORD"]="${PRODUCT_DESCRIPTIONS[${PRODUCT_AGENT}]} account password"
  ["$OPTION_WEBLOGIC_PORT"]='Weblogic administration port'
  ["$OPTION_WEBLOGIC_USER"]='Weblogic administration username'
  ["$OPTION_WEBLOGIC_PASSWORD"]='Weblogic account password'
  ["$OPTION_SUDOERS_FILE_NAME"]="name of the ${DESCRIPTION_SUDOERS_FILE}"
  ["$OPTION_SUDOERS_FILE_PERMISSIONS"]="file permissions on the ${DESCRIPTION_SUDOERS_FILE}"
  ["$OPTION_SWAP_GOAL"]="desired size of the ${DESCRIPTION_SWAP}"
  ["$OPTION_SWAP_FILE_NAME"]="name of the ${DESCRIPTION_SWAP_FILE}"
  ["$OPTION_SWAP_FILE_PERMISSIONS"]="file permissions of the ${DESCRIPTION_SWAP_FILE}"
  ["$OPTION_SYSCTL_FILE_NAME"]="name of the ${DESCRIPTION_SYSCTL_FILE}"
  ["$OPTION_SYSCTL_FILE_PERMISSIONS"]="file permissions on the ${DESCRIPTION_SYSCTL_FILE}"
  ["$OPTION_LIMITS_DATABASE_FILE_NAME"]="name of the ${DESCRIPTION_LIMITS_DATABASE_FILE}"
  ["$OPTION_LIMITS_MANAGER_FILE_NAME"]="name of the ${DESCRIPTION_LIMITS_MANAGER_FILE}"
  ["$OPTION_LIMITS_FILE_PERMISSIONS"]="file permissions on the system limits settings for the Oracle products"
  ["$OPTION_CONTROLLER_FILE_NAME"]="name of the ${DESCRIPTION_CONTROLLER_FILE}"
  ["$OPTION_CONTROLLER_FILE_PERMISSIONS"]="file permissions on the ${DESCRIPTION_CONTROLLER_FILE}"
  ["$OPTION_SYSTEMD_SERVICE_NAME"]="name of the $DESCRIPTION_SYSTEMD_SERVICE"
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

######################
# Installation steps #
######################

declare -r INSTALLATION_STEP_EXTRACTED='INSTALLATION_STEP_EXTRACTED'
declare -r INSTALLATION_STEP_PROVISIONED='INSTALLATION_STEP_PROVISIONED'
declare -r INSTALLATION_STEP_INSTALLED='INSTALLATION_STEP_INSTALLED'
declare -r INSTALLATION_STEP_CONFIGURED='INSTALLATION_STEP_CONFIGURED'
declare -r INSTALLATION_STEP_PREPARED='INSTALLATION_STEP_PREPARED'
declare -r INSTALLATION_STEP_MODIFIED='INSTALLATION_STEP_MODIFIED'
declare -r INSTALLATION_STEP_PATCHED='INSTALLATION_STEP_PATCHED'

###################
# Other constants #
###################

declare -r CHARACTER_SINGLE_QUOTE="'"
declare -r CHARACTER_DOUBLE_QUOTE="\""
declare -r CHARACTER_BACKSLASH='\'
declare -r -i VALUE_TRUE=0
declare -r -i VALUE_FALSE=1
declare -r -i HELP_INDENT_LENGTH=2
declare -r ORAINST_FILE_NAME='/etc/oraInst.loc'
declare -r ORATAB_FILE_NAME='/etc/oratab'
declare -r FSTAB_FILE_NAME='/etc/fstab'

declare -r LogFile="/tmp/OEM-$(date '+%F-%T').log"
touch "$LogFile"

################################ Utility functions ################################

################################################################################
## @fn echoLog
##
## @brief Echo the parameters to the screen and log file.
##
## @param[in] ... Parameters to echo.
##
## @return RETCODE_SUCCESS
################################################################################
echoLog() {
  echo "[$(date '+%F-%T')]" "$@" | tee -a "$LogFile"
  return $RETCODE_SUCCESS
}

################################################################################
## @fn getSourceName
##
## @brief Echo the name(s) of the source.
##
## @param[in] Source The source for which to echo the name, or names if the
##                   value refers to multiple sources.
##
## @return RETCODE_SUCCESS
################################################################################
getSourceName() {
  local -r -i Source=${1:-$OPTION_SOURCE_UNSET}
  if [[ $OPTION_SOURCE_ALL -eq $Source ]] ; then
    echo "${OPTION_SOURCE_NAMES[${OPTION_SOURCE_COMMAND}]}, ${OPTION_SOURCE_NAMES[${OPTION_SOURCE_FILE}]}, ${OPTION_SOURCE_NAMES[${OPTION_SOURCE_PROGRAM}]}"
  elif [[ $OPTION_SOURCE_BOTH -eq $Source ]] ; then
    echo "${OPTION_SOURCE_NAMES[${OPTION_SOURCE_COMMAND}]}, ${OPTION_SOURCE_NAMES[${OPTION_SOURCE_FILE}]}"
  elif [[ $OPTION_SOURCE_COMMAND -eq $Source ]] || [[ $OPTION_SOURCE_FILE -eq $Source ]] || [[ $OPTION_SOURCE_PROGRAM -eq $Source ]] ; then
    echo "${OPTION_SOURCE_NAMES[${Source}]}"
  else
    echo
  fi
  return $RETCODE_SUCCESS
}

################################################################################
## @fn echodMessage
##
## @brief Echo a message.
##
## @param[in] Message    The message to echo.
## @param[in] Parameter1 An optional parameter for the message that will be
##                       displayed between single-quotes.
## @param[in] Parameter2 Another optional parameter for the message that will be
##                       displayed between parenthesis.
## @param[in] Prefix     An optional prefix to insert before the message.  The
##                       default prefix is "...".
## @param[in] Tag        An optional tag to be inserted between square brackets
##                       after the prefix and before the message.
##
## @return RETCODE_SUCCESS
################################################################################
echoMessage() {
  local -r Message="${1:-}"
  local -r Parameter1="${2:-}"
  local -r Parameter2="${3:-}"
  local -r Prefix="${4:-}"
  local Tag="${5:-}"
  if [[ -n "$Message" ]] ; then
    if [[ -n "$Tag" ]] ; then
      Tag="[${Tag}] "
    fi
    if [[ -n "$Parameter1" ]] && [[ -n "$Parameter2" ]] ; then
      echoLog "${Prefix}${Tag}${Message^}:" "'${Parameter1}'" "(${Parameter2})"
    elif [[ -n "$Parameter2" ]] ; then
      echoLog "${Prefix}${Tag}${Message^}" "(${Parameter2})"
    elif [[ -n "$Parameter1" ]] ; then
      echoLog "${Prefix}${Tag}${Message^}:" "'${Parameter1}'"
    else
      echoLog "${Prefix}${Tag}${Message^}"
    fi
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
  echoLog "$@"
  return $RETCODE_SUCCESS
}

################################################################################
## @fn echoCommandMessage
##
## @brief Echo a command completion notice message.
##
## @param[in] Message    The message to echo.
## @param[in] Parameter1 An optional parameter for the message that will be
##                       displayed between single-quotes.
## @param[in] Parameter2 Another optional parameter for the message that will be
##                       displayed between parenthesis.
## @param[in] Prefix     An optional prefix to insert before the message.  The
##                       default prefix is "...".
##
## @return RETCODE_SUCCESS
################################################################################
echoCommandMessage() {
  echoMessage "$1" "$2" "$3" "${4:-...}" ''
  return $?
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
## @param[in] Prefix     An optional prefix to insert before the message.  The
##                       default prefix is "...".
##
## @return The return code.
################################################################################
echoError() {
  local -r -i Retcode=${1:-$RETCODE_INTERNAL_ERROR}
  if [[ $RETCODE_SUCCESS -ne $Retcode ]] ; then
    echoCommandMessage "${2:-unexpected error}" "$3" "$4" "$5" 'ERROR'
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
    local Output=$(printf ' %.0s' $(seq 1 $HELP_INDENT_LENGTH))
    Output="$Output"$(printf '%s%s: ' "$Prefix" "$Item")
    if [[ 0 -lt $Padding ]] ; then
      Output="$Output"$(printf ' %.0s' $(seq 1 $Padding))
    fi
    Output="$Output"$(printf '%s' "${Description^}")
    if [[ -n "$SourceName" ]] || [[ -n "$DefaultValue" ]] ; then
      if [[ -n "$SourceName" ]] && [[ -n "$DefaultValue" ]] ; then
        Output="$Output"$(printf ' (source: %s; default=%s)' "$SourceName" "$DefaultValue")
      elif [[ -n "$SourceName" ]] ; then
        Output="$Output"$(printf ' (source: %s)' "$SourceName")
      elif [[ -n "$DefaultValue" ]] ; then
        Output="$Output"$(printf ' (default=%s)' "$DefaultValue")
      fi
    fi
    echoLog "$Output"
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
  echoLog "Usage: ${PROGRAM} [options...] < Command > [ Product ]"
  echoLog "A utility script to install and uninstall the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} and the ${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]}."
  echoLog
  echoLog 'Commands:'
  for Item in "${COMMANDS[@]}" ; do
    echoHelpItem 'COMMAND_DESCRIPTIONS' "$Item"
  done
  echoLog
  echoLog "Products (only for the commands ${COMMAND_INSTALL} and ${COMMAND_UNINSTALL}, when no target provided specifies all products):"
  for Item in "${PRODUCTS[@]}" ; do
    echoHelpItem 'PRODUCT_DESCRIPTIONS' "$Item"
  done
  echoLog
  echoLog 'Options:'
  for Item in "${OPTIONS[@]}" ; do
    if [[ $((OPTION_SOURCE_COMMAND & ${OPTION_SOURCES[$Item]})) -eq $OPTION_SOURCE_COMMAND ]] ; then
      echoHelpItem 'OPTION_DESCRIPTIONS' "$Item" "$OPTION_PREFIX" "$(getSourceName ${OPTION_SOURCES[${Item}]})" "${OPTION_DEFAULT_VALUES[${Item}]}"
    fi
  done
  echoLog
  if [[ $VALUE_TRUE -eq $bComplete ]] ; then
    echoLog 'Summary:'
    echoLog "This program is designed for the simplified installation and uninstallation of ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} 19c and ${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} 13cc on Oracle Linux 8.  A new Oracle Database instance is launched during the install process for immediate use by ${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]}.  The installation is standardized without many options and is not designed to be bullet-proof."
    echoLog
    echoLog 'Detailed description:'
    echoLog "The Oracle software must be procured and provided to this program, by aid of the various program options listed above, as zip files downloaded from Oracle eDelivery or My Oracle Support.  The program installs the Oracle products in their respective home directories, the structure of which follows the guidelines of the Oracle Optimal Flexible Architecture (OFA) standard.  The installation of the Oracle software is performed using the ${OPTION_DESCRIPTIONS[${OPTION_INSTALLATION_USER}]} and the ${OPTION_DESCRIPTIONS[${OPTION_INSTALLATION_GROUP}]}.  If these ${OPTION_DESCRIPTIONS[${OPTION_INSTALLATION_USER}]} and ${OPTION_DESCRIPTIONS[${OPTION_INSTALLATION_GROUP}]} do not already exist on the system, the program automatically creates them.  The ${OPTION_DESCRIPTIONS[${OPTION_INSTALLATION_USER}]} is also automatically added to the operating system list of Sudoers, if it is not already in this list.  Many system settings are automatically adjusted as per the requirements of the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]}.  The installation process is fully automated by use of the silent installer options of the Oracle software."
    echoLog
    echoLog 'Installation steps:'
    echoLog '1- Configure a machine that meets the minimum requirements listed below.'
    echoLog "2- Download the ${DESCRIPTION_DATABASE_PACKAGE_FILE} from https://edelivery.oracle.com or from https://support.oracle.com.  The zip file must be provided to the program with the options '${OPTION_DATABASE_PACKAGE_FILE_NAME}'."
    echoLog "3- Download the latest ${DESCRIPTION_DATABASE_OPATCH_FILE} and ${DESCRIPTION_DATABASE_UPGRADE_PATCH_FILE}, and provide them to the program with the options '${OPTION_DATABASE_OPATCH_FILE_NAME}' and '${OPTION_DATABASE_UPGRADE_PATCH_FILE_NAME}', respectively."
    echoLog "4- Download the ${DESCRIPTION_MANAGER_FILES} from https://edelivery.oracle.com or from https://support.oracle.com.  There should be five zip files, which must be provided to the program as a comma-separated list with the parameter '${OPTION_MANAGER_PACKAGES_FILE_NAMES}'."
    echoLog "5- Run this program with the '${COMMAND_INSTALL}' command with the necessary program parameters.  For example, to install the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]}:"
    echoLog "       ${PROGRAM} ${CHARACTER_BACKSLASH}"
    echoLog "           ${OPTION_PREFIX}${OPTION_DATABASE_PACKAGE_FILE_NAME}=${OPTION_DEFAULT_VALUES[${OPTION_DATABASE_PACKAGE_FILE_NAME}]} ${CHARACTER_BACKSLASH}"
    echoLog "           ${OPTION_PREFIX}${OPTION_DATABASE_OPATCH_FILE_NAME}=${OPTION_DEFAULT_VALUES[${OPTION_DATABASE_OPATCH_FILE_NAME}]} ${CHARACTER_BACKSLASH}"
    echoLog "           ${OPTION_PREFIX}${OPTION_DATABASE_UPGRADE_PATCH_FILE_NAME}=${OPTION_DEFAULT_VALUES[${OPTION_DATABASE_UPGRADE_PATCH_FILE_NAME}]} ${CHARACTER_BACKSLASH}"
    echoLog "           ${COMMAND_INSTALL} ${PRODUCT_DATABASE}"
    echoLog
    echoLog 'Minimum machine requirements:'
    echoLog '- CPUs: 2'
    echoLog "- Memory: ${OPTION_DEFAULT_VALUES[${OPTION_SWAP_GOAL}]}GB"
    echoLog '- Storage: 100GB'
    echoLog
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
  if [[ -n "$Message" ]] ; then
    echoMessage "$Message" "$2" "$3" '' 'INFO'
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
  local -r SourceName=$(getSourceName $3)
  local -r Tag="${4:-}"
  if [[ -n "$Option" ]] ; then
    local -r -i Padding=$(($OPTION_MAXIMUM_LENGTH - ${#Option}))
    if [[ -n "$Tag" ]] ; then
      local Output=$(printf '[%s] ' "$Tag")
    else
      local Output=''
    fi
    Output="${Output}"$(printf '%s:' "${Option}")
    if [[ -n "$Value" ]] ; then
      if [[ 0 -lt $Padding ]] ; then
        Output="${Output}"$(printf ' %.0s' $(seq 1 $Padding))
      fi
      Output="${Output}"$(printf ' %s' "$Value")
      if [[ -n "$SourceName" ]] ; then
        Output="${Output}"$(printf ' (source: %s)' "$SourceName")
      fi
    fi
    echoLog "$Output"
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
  echoLog '='
  echoLog $(printf '==== %s ====' "${1^}")
  echoLog '='
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
  echoLog $(printf '=%.0s' $(seq 1 $Length))
  echoLog $(printf '= %s =' "${Title^}")
  echoLog $(printf '=%.0s' $(seq 1 $Length))
  return $RETCODE_SUCCESS
}

################################################################################
## @fn executeCommand
##
## @brief Echo a shell command and its parameters, then execute it.
##
## @param[in] ... The command and its parameters.
##
## @return The return code of the function execution.
################################################################################
executeCommand() {
  echoCommand "$@"
  set -o pipefail
  ($@) | tee -a "$LogFile"
  local -r Retcode=$?
  set +o pipefail
  return $Retcode
}

################################################################################
## @fn executeCommandOutput
##
## @brief Echo a shell command and its parameters, and execute it and capture
##        its output into a provided variable.
##
## @param[out] Output The name of a variable in which to store the output of the
##                    of the command.
## @param[in] ...     The command and its parameters.
##
## @return The return code of the function execution.
################################################################################
executeCommandOutput() {
  local DummyOutput=''
  local -n _Output="${1:-DummyOutput}"
  shift
  echoCommand "$@"
  _Output=$($@)
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
## @return A return code equivalent to the exit code.
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
## @param[in]  Quote    An optional quote character used in the line (' or ").
##
## @return The value of the parameter Retcode if it denotes an error, or
##         otherwise the return code of the function execution.
################################################################################
appendLine() {
  local -i Retcode=${1:-$RETCODE_SUCCESS}
  local -r Filename="$2"
  local -r Line="$3"
  local -r Quote="$4"

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
          return $?
        fi
      done < <(sudo 'grep' '-o' '^[^#]*' "$Filename")
      if [[ -n "$Quote" ]] && [[ "'" == "$Quote" ]] ; then
        local -r Command='echo "'"$Line"'" >> '"'${Filename}'"
      else
        local -r Command="echo '${Line}' >> '${Filename}'"
      fi
      echoCommand 'sudo' 'sh' '-c' "$Command"
      sudo 'sh' '-c' "$Command"
      processCommandCode $? 'failed to modify file' "$Filename"
      Retcode=$?
    fi
  fi

  return $Retcode
}

################################################################################
## @fn setDirectoryAttributes
##
## @brief Set the ownership and file system permissions of a directory.
##
## @param[in] Retcode              A return code that causes the function to
##                                 return immediately when the code denotes an
##                                 error.  The default value of this parameter
##                                 is RETCODE_SUCCESS.
## @param[in] User                 The user to own the directory.
## @param[in] Group                The group to own the directory.
## @param[in] DirectoryDescription The description of the directory
## @param[in] DirectoryName        The name of the directory.
## @param[in] Permissions          The file system permissions to apply on the
##                                 directory.
##
## @return The value of the parameter Retcode if it denotes an error, or the
##         return code of the function execution.
################################################################################
setDirectoryAttributes() {
  local -i Retcode=${1:-$RETCODE_SUCCESS}
  local -r User="${2:-}"
  local -r Group="${3:-}"
  local -r DirectoryDescription="${4:-directory}"
  local -r DirectoryName="${5:-}"
  local -r Permissions="${6:-}"

  if [[ -n "$DirectoryName" ]] ; then
    if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
      executeCommand 'sudo' 'test' '-d' "$DirectoryName"
      processCommandCode $? "the ${DirectoryDescription} does not exist or is inaccessible" "$DirectoryName"
      Retcode=$?
    fi

    if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ -n "$User" ]] && [[ -n "$Group" ]] ; then
      executeCommand 'sudo' 'chown' '-R' "${User}:${Group}" "$DirectoryName"
      processCommandCode $? "failed to set the ownership of the ${DirectoryDescription}" "$DirectoryName" "${User}:${Group}"
      Retcode=$?
    fi

    if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ -n "$Permissions" ]] ; then
      executeCommand 'sudo' 'chmod' '-R' "$Permissions" "$DirectoryName"
      processCommandCode $? "failed to set the file system permissions of the ${DirectoryDescription}" "$DirectoryName" "$Permissions"
      Retcode=$?
    fi
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
## @param[in] User                 An optional user with which to delete the
##                                 directory.
##
## @return The return code of the function execution.
################################################################################
deleteDirectory() {
  local -r DirectoryDescription="${1:-directory}"
  local -r DirectoryName="${2:-}"
  local -r User="${3:-root}"
  local -i Retcode=$RETCODE_SUCCESS

  if [[ -n "$DirectoryName" ]] && [[ '/' != "$DirectoryName" ]] ; then
    executeCommand 'sudo' '-u' "$User" 'test' '-d' "$DirectoryName"
    if [[ 0 -eq $? ]] ; then
      echoCommandSuccess
      executeCommand 'sudo' '-u' "$User" 'rm' '-rf' "$DirectoryName"
      processCommandCode $? "failed to delete ${DirectoryDescription}" "$DirectoryName"
    else
      echoCommandMessage "the ${DirectoryDescription} does not exist or is inacessible" "$DirectoryName"
    fi
    Retcode=$?
  fi

  return $Retcode
}

################################################################################
## @fn deleteFile
##
## @brief Delete a file.
##
## @param[in] FileDescription The description of the file.
## @param[in] FileName        The name of the file to delete.
## @param[in] User            An optional user with which to delete the file.
##
## @return The return code of the function execution.
################################################################################
deleteFile() {
  local -r FileDescription="${1:-file}"
  local -r FileName="${2:-}"
  local -r User="${3:-root}"
  local -i Retcode=$RETCODE_SUCCESS

  if [[ -n "$FileName" ]] ; then
    executeCommand 'sudo' '-u' "$User" 'test' '-f' "$FileName"
    if [[ 0 -eq $? ]] ; then
      echoCommandSuccess
      executeCommand 'sudo' '-u' "$User" 'rm' '-f' "$FileName"
      processCommandCode $? "failed to delete ${FileDescription}" "$FileName"
    else
      echoCommandMessage "the ${FileDescription} does not exist or is inacessible" "$FileName"
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
  local -r Permissions="${4:-}"
  local -r DirectoryDescription="${5:-directory}"
  local -r DirectoryName="${6:-}"
  local -r ParentDirectoryDescription="${7:-parent directory}"
  local -r ParentDirectoryName="${8:-}"
  local -r -i bRecreate=${9:-${VALUE_FALSE}}
  local -i bCreate=$VALUE_FALSE

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ -z "$DirectoryName" ]] ; then
    echoError $RETCODE_INTERNAL_ERROR "the ${DirectoryDescription} was not provided"
    Retcode=$?
  fi

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-d' "$DirectoryName"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${DirectoryDescription} already exists" "$DirectoryName"
      executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-r' "$DirectoryName" '-a' '-w' "$DirectoryName"
      if [[ 0 -eq $? ]] ; then
        if [[ $VALUE_TRUE -eq $bRecreate ]] ; then
          bCreate=$VALUE_TRUE
          echoInfo "the ${DirectoryDescription} will be re-created" "$DirectoryName"
          deleteDirectory "$DirectoryDescription" "$DirectoryName" "$User"
        else
          echoInfo "the ${DirectoryDescription} is accessible and will not be re-created" "$DirectoryName"
        fi
      else
        echoError $RETCODE_OPERATION_ERROR "the ${DirectoryDescription} is not accessible" "$DirectoryName"
      fi
      Retcode=$?
    else
      echoCommandMessage "the ${DirectoryDescription} does not exist" "$DirectoryName"
      bCreate=$VALUE_TRUE
    fi
  fi

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ $VALUE_TRUE -eq $bCreate ]] ; then
    if [[ -z "$Permissions" ]] ; then
      executeCommand 'sudo' 'mkdir' '-p' "$DirectoryName"
    else
      executeCommand 'sudo' 'mkdir' '-m' "$Permissions" '-p' "$DirectoryName"
    fi
    processCommandCode $? "failed to create the ${DirectoryDescription}" "$DirectoryName"
    Retcode=$?
    if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
      if [[ -n "$ParentDirectoryName" ]] && [[ "${DirectoryName:0:$((${#ParentDirectoryName}+1))}" == "${ParentDirectoryName}/" ]] ; then
        setDirectoryAttributes $Retcode "$User" "$Group" "$ParentDirectoryDescription" "$ParentDirectoryName" ''
      else
        setDirectoryAttributes $Retcode "$User" "$Group" "$DirectoryDescription" "$DirectoryName" ''
      fi
      Retcode=$?
    fi
  fi

  return $Retcode
}

################################################################################
## @fn createFile
##
## @brief Create a file and populate it with the provided content.
##
## @param[in]  Retcode         A return code that causes the function to return
##                             immediately when the code denotes an error.  The
##                             default value of this parameter is
##                             RETCODE_SUCCESS.
## @param[in]  User            The user to own the response file.
## @param[in]  Group           The group to own the response file.
## @param[in]  Permissions     The file permissions of the response file.
## @param[in]  FileDescription The description of the response file.
## @param[in]  FileName        The name of the response file.
## @param[in]  Content         The content of the response file.  The content
##                             content should not contain any single quotes.
## @param[in]  bOverwrite      Whether to overwrite the file if it already
##                             exists.
## @param[out] bCreated        Whether the file was newly created.
##
## @return The value of the parameter Retcode if it denotes an error, or the
##         return code of the function execution.
################################################################################
createFile() {
  local -r ContentDummy=''
  local -i CreatedDummy=$VALUE_FALSE
  local -i Retcode=${1:-$RETCODE_SUCCESS}
  local -r User="${2:-:root}"
  local -r Group="${3:-:root}"
  local -r Permissions="${4:-}"
  local -r FileDescription="${5:-file}"
  local -r FileName="${6:-}"
  local -n Content="${7:-ContentDummy}"
  local -r -i bOverwrite="${8:-$VALUE_FALSE}"
  local -n bCreated="${9:-CreatedDummy}"
  local -i bSetOwner=$VALUE_FALSE

  bCreated=$VALUE_FALSE

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ -z "$FileName" ]] ; then
    echoError $RETCODE_INTERNAL_ERROR "the ${FileDescription} was not provided"
    Retcode=$?
  fi

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-r' "$FileName"
    if [[ 0 -eq $? ]] ; then
      if [[ $VALUE_TRUE -eq bOverwrite ]] ; then
        echoCommandMessage "the ${FileDescription} already exists and will be overwritten" "$FileName"
      else
        echoCommandMessage "the ${FileDescription} already exists" "$FileName"
        return $?
      fi
    else
      echoCommandMessage "the ${FileDescription} does not exist" "$FileName"
    fi
  fi

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    if [[ -z "$Content" ]] ; then
      executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'touch' "$FileName"
    else
      bSetOwner=$VALUE_TRUE
      echoCommand 'sudo' 'sh' '-c' "echo 'response file contents' >> '${FileName}'"
      sudo 'sh' '-c' "echo '${Content}' > '${FileName}'"
    fi
    processCommandCode $? "the ${FileDescription} was not created" "$FileName"
    Retcode=$?
    if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
      bCreated=$VALUE_TRUE
    fi
  fi

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ $VALUE_TRUE -eq $bSetOwner ]] ; then
    executeCommand 'sudo' 'chown' "${User}:${Group}" "$FileName"
    processCommandCode $? "failed to set the ownership of the ${FileDescription}" "$FileName" "${User}:${Group}"
    Retcode=$?
  fi

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ -n "$Permissions" ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'chmod' "$Permissions" "$FileName"
    processCommandCode $? "failed to set the file system permissions of the ${FileDescription}" "$FileName" "$Permissions"
    Retcode=$?
  fi

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ $VALUE_TRUE -eq $bSetOwner ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-r' "$FileName"
    processCommandCode $? "the ${FileDescription} does not exist or is inaccessible" "$FileName"
    Retcode=$?
  fi

  if [[ $RETCODE_SUCCESS -ne $Retcode ]] && [[ $VALUE_TRUE -eq $bCreated ]] ; then
    deleteFile "$FileDescription" "$FileName" "$User"
    bCreated=$VALUE_FALSE
  fi

  return $Retcode
}

################################################################################
## @fn createFileLink
##
## @brief Create a symbolic link to a file.
##
## @param[in] Retcode         A return code that causes the function to return
##                            immediately when the code denotes an error.  The
##                            default value of this parameter is
##                            RETCODE_SUCCESS.
## @param[in] User            The user to own the symbolic link.
## @param[in] Group           The group to own the symbolic link.
## @param[in] FileDescription The description of the file.
## @param[in] FileName        The name of the file.
## @param[in] LinkName        The file name of the symbolic link.
##
## @return The value of the parameter Retcode if it denotes an error, or the
##         return code of the function execution.
################################################################################
createFileLink() {
  local -i Retcode=${1:-$RETCODE_SUCCESS}
  local -r User="${2:-:root}"
  local -r Group="${3:-:root}"
  local -r FileDescription="${4:-file}"
  local -r FileName="${5:-}"
  local -r LinkName="${6:-}"
  local -i bProceed=$VALUE_TRUE

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    if [[ -z "$LinkName" ]] ; then
      echoError $RETCODE_INTERNAL_ERROR "the file name for the symbolic link to the ${FileDescription} was not provided"
    else
      executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$LinkName"
      if [[ 0 -eq $? ]] ; then
        bProceed=$VALUE_FALSE
        echoCommandMessage "the destination ${FileDescription} already exists" "$LinkName"
      else
        echoCommandMessage "the destination ${FileDescription} does not exist" "$LinkName"
      fi
    fi
    Retcode=$?
  fi

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ $VALUE_TRUE -eq $bProceed ]] ; then
    if [[ -z "$FileName" ]] ; then
      echoError $RETCODE_INTERNAL_ERROR "the source file name for the ${FileDescription} was not provided"
    else
      executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$FileName"
      processCommandCode $? "source file for ${FileDescription} does not exist or is inacessible" "$FileName"
    fi
    Retcode=$?
  fi

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ $VALUE_TRUE -eq $bProceed ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'ln' '-s' "$FileName" "$LinkName"
    processCommandCode $? "failed to create symbolic link to ${FileDescription}" "$FileName" "$LinkName"
    Retcode=$?
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

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ -n "$FileName" ]] ; then
    createFile $Retcode "$User" "$Group" '644' 'installation progress marker file' "$FileName"
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

#echo '-----------'
#echo 'extractFile'
#echo '-----------'
#echo "Retcode:              ${Retcode}"
#echo "User:                 ${User}"
#echo "Group:                ${Group}"
#echo "FileDescription:      ${FileDescription}"
#echo "FileName:             ${FileName}"
#echo "DirectoryDescription: ${DirectoryDescription}"
#echo "DirectoryName:        ${DirectoryName}"

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
## @fn determinePatchNumber
##
## @brief Determine the patch number from the package zip file.
##
## @param[out] PatchNumber         The patch number.
## @param[in]  FileName            The name of the package zip file that
##                                 contains the patch.
## @param[in]  FileNameDescription The description of the name of the package
##                                 zip file.
##
## @return The return code of the function execution.
################################################################################
determinePatchNumber() {
  local DeterminedPatchNumberDummy=''
  local -n DeterminedPatchNumber="${1:-DeterminedPatchNumberDummy}"
  local -r FileName="${2:-}"
  local -r FileNameDescription="${3:-name of the patch file}"

  if [[ -z "$FileName" ]] ; then
    DeterminedPatchNumber=''
    echoError $RETCODE_PARAMETER_ERROR "the ${FileNameDescription} was not provided"
  else
    echoCommand 'basename' "$FileName" '|' 'sed' '-E' 's/p([0-9]*)_.*\.zip/\1/g'
    DeterminedPatchNumber=$(basename "$FileName" | sed -E 's/p([0-9]*)_.*\.zip/\1/g')
    local -i Code=$?
    if [[ 0 -eq $Code ]] && [[ -z "$DeterminedPatchNumber" ]] ; then
      Code=1
    fi
    processCommandCode $Code "unable to determine a patch number from the ${FileNameDescription}" "$FileName"
  fi

  return $?
}

################################################################################
## @fn extractPatch
##
## @brief Extract an Oracle patch package zip file.
##
## @param[in] User                 The installation user.
## @param[in] Group                The installation group.
## @param[in] PatchDescription     The description of the patch.
## @param[in] FileDescription      The description of the package zip file that
##                                 contains the patch.
## @param[in] FileName             The name of the package zip file that
##                                 contains the patch.
## @param[in] FileNameDescription  The description of the name of the package
##                                 zip file.
## @param[in] DirectoryDescription The description of the directory in which
##                                 the package zip file will be extracted.
## @param[in] DirectoryName        The name of the directory in which the
##                                 package zip file will be extracted.
## @param[in] PatchNumber          The patch number.  This parameter is optional
##                                 and if it is missing, the patch nnumber will
##                                 be determined using the patch file name.
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
  local -r User="${1:-}"
  local -r Group="${2:-}"
  local -r PatchDescription="${3:-patch}"
  local -r FileDescription="${4:-patch file}"
  local -r FileName="${5:-}"
  local -r FileNameDescription="${6:-name of the patch file}"
  local -r DirectoryDescription="${7:-extraction directory}"
  local -r DirectoryName="${8:-}"
  local PatchNumber="${9:-}"
  local -i Retcode=$RETCODE_SUCCESS

#echo '------------'
#echo 'extractPatch'
#echo '------------'
#echo "User:                 ${User}"
#echo "Group:                ${Group}"
#echo "PatchDescription:     ${PatchDescription}"
#echo "FileDescription:      ${FileDescription}"
#echo "FileName:             ${FileName}"
#echo "FileNameDescription:  ${FileNameDescription}"
#echo "DirectoryDescription: ${DirectoryDescription}"
#echo "DirectoryName:        ${DirectoryName}"
#echo "HomeDirectoryName:    ${HomeDirectoryName}"

  if [[ -z "$PatchNumber" ]] ; then
    determinePatchNumber 'PatchNumber' "$FileName" "$FileNameDescription"
    Retcode=$?
  fi

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ -n "$FileName" ]] && [[ -n "$DirectoryName" ]] ; then
    local -r PatchDirectoryDescription="home directory for ${PatchDescription} '${PatchNumber}'"
    local -r PatchDirectoryName="${DirectoryName}/${PatchNumber}"
#echo "PatchNumber:          ${PatchNumber}"
#echo "PatchDirectoryName:   ${PatchDirectoryName}"
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "${PatchDirectoryName}/README.txt" '-o' '-f' "${PatchDirectoryName}/README.html"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${PatchDirectoryDescription} already exists" "$PatchDirectoryName"
      echoInfo "skipping extraction of ${PatchDescription}" "$PatchNumber"
     else
      echoCommandMessage "the ${PatchDirectoryDescription} does not exist or is inaccessible" "$PatchDirectoryName"
      extractFile $Retcode "$User" "$Group" "$FileDescription" "$FileName" "$DirectoryDescription" "$DirectoryName"
      setDirectoryAttributes $? "$User" "$Group" "$PatchDirectoryDescription" "$PatchDirectoryName"
      Retcode=$?
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-d' "$PatchDirectoryName" '-a' '-r' "$PatchDirectoryName"
        processCommandCode $? "the ${PatchDirectoryDescription} does not exist, is inaccessible, or cannot be read" "$PatchDirectoryName"
        Retcode=$?
      else
        deleteDirectory "$PatchDirectoryDescription" "$PatchDirectoryName" "$User"
      fi
    fi
  fi

  return $Retcode
}

################################################################################
## @fn applyPatch
##
## @brief Apply a patch to an Oracle product.
##
## @param[in] User                 The installation user.
## @param[in] Group                The installation group.
## @param[in] PatchDescription     The description of the patch.
## @param[in] FileDescription      The description of the package zip file that
##                                 contains the patch.
## @param[in] FileName             The name of the package zip file that
##                                 contains the patch.
## @param[in] FileNameDescription  The description of the name of the package
##                                 zip file.
## @param[in] DirectoryDescription The description of the directory in which the
##                                 package zip file has been or
##                                 will be extracted.
## @param[in] DirectoryName        The name of the directory in which the
##                                 package zip file has been or will be
##                                 extracted.
## @param[in] HomeDirectoryName    The name of the home directory of the
##                                 Oracle product to be patched.
## @param[in] MarkerBase           The file name to use for the patch
##                                 installion marker file.  The patch number
##                                 will be appended to the name of the marker
##                                 file.
##
## @note All product file and directory names should be in the absolute form.
##
## @note This function performs the following steps:
##
## @li Validate whether the patch has already been applied.
## @li Validate that the patch has already been extracted.  If not, extract it.
## @li Apply the patch.
##
## @return The return code of the function execution.
################################################################################
applyPatch() {
  local -r User="${1:-}"
  local -r Group="${2:-}"
  local -r PatchDescription="${3:-patch}"
  local -r FileDescription="${4:-patch file}"
  local -r FileName="${5:-}"
  local -r FileNameDescription="${6:-name of the patch file}"
  local -r DirectoryDescription="${7:-}"
  local -r DirectoryName="${8:-}"
  local -r HomeDirectoryName="${9:-}"
  local -r MarkerBase="${10:-}"
  local PatchNumber=''

#echo '----------'
#echo 'applyPatch'
#echo '----------'
#echo "PatchDescription:     ${PatchDescription}"
#echo "FileDescription:      ${FileDescription}"
#echo "FileName:             ${FileName}"
#echo "FileNameDescription:  ${FileNameDescription}"
#echo "DirectoryDescription: ${DirectoryDescription}"
#echo "DirectoryName:        ${DirectoryName}"
#echo "HomeDirectoryName:    ${HomeDirectoryName}"
#echo "MarkerBase:           ${MarkerBase}"

  determinePatchNumber 'PatchNumber' "$FileName" "$FileNameDescription"
  local -i Retcode=$?

#echo "PatchNumber:          ${PatchNumber}"

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ -n "$PatchNumber" ]] ; then
    local -r PatchDirectoryName="${DirectoryName}/${PatchNumber}"
    if [[ -n "$MarkerBase" ]] ; then
      local -r Marker="${MarkerBase}_${PatchNumber}"
#echo "Marker:               ${Marker}"
    else
      local -r Marker=''
    fi

    ### Verify whether the patch has already been applied. ###

    if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ -n "$Marker" ]] ; then
      executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$Marker"
      if [[ 0 -eq $? ]] ; then
        echoCommandMessage "the ${PatchDescription} is already applied" "$PatchNumber" "$FileName"
        return $?
      else
        echoCommandMessage "the ${PatchDescription} has not been applied" "$PatchNumber" "$FileName"
      fi
    fi

    ### Extract the patch. ###

    if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
      extractPatch "$User" "$Group" "$PatchDescription" "$FileDescription" "$FileName" "$FileNameDescription" "$DirectoryDescription" "$DirectoryName" "$PatchNumber"
      Retcode=$?
    fi

    ### Apply the patch. ###

    if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
      executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "${PatchDirectoryName}/bundle.xml"
      if [[ 0 -eq $? ]] ; then
        local -r Patcher='OMSPatcher/omspatcher'
        local -r Parameters='-bitonly'
      else
        local -r Patcher='OPatch/opatch'
        local -r Parameters=''
      fi
      echoCommand 'sudo' '-u' "$User" '-g' "$Group" 'sh' '-c' "\"(export ORACLE_HOME='${HomeDirectoryName}'; cd '${PatchDirectoryName}'; ${HomeDirectoryName}/${Patcher} apply -silent ${Parameters} -invPtrLoc '${HomeDirectoryName}/oraInst.loc')\""
      ( sudo '-u' "$User" '-g' "$Group" 'sh' '-c' "( export ORACLE_HOME='${HomeDirectoryName}'; cd '${PatchDirectoryName}'; ${HomeDirectoryName}/${Patcher} apply -silent ${Parameters} -invPtrLoc '${HomeDirectoryName}/oraInst.loc' )" ) | tee -a "$LogFile"
      processCommandCode $? "failed to apply ${PatchDescription}" "$PatchNumber" "$PatchDirectoryName"
      createMarker $? "$User" "$Group" "$Marker"
      Retcode=$?
    fi
  fi

  return $Retcode
}

################################################################################
## @fn updatePatcher
##
## @brief Update the Oracle product patching utility.
##
## @param[in] User                 The installation user.
## @param[in] Group                The installation group.
## @param[in] PatcherDescription   The description of the patching utility.
## @param[in] FileDescription      The description of the package zip file that
##                                 contains the updated patching utility.
## @param[in] FileName             The name of the package zip file that
##                                 contains the updated patching utility.
## @param[in] DirectoryDescription The description of the installation
##                                 directory of the patching utility.
## @param[in] DirectoryName        The installation directory of the patching
##                                 utility.
## @param[in] Marker               The name of a file which presence denotes
##                                 that the patching utility has been updated.
##                                 This function creates the file upon successful
##                                 successful completion of the update.
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
## @return The return code of the function execution.
################################################################################
updatePatcher() {
  local -r User="${1:-}"
  local -r Group="${2:-}"
  local -r PatcherDescription="${3:-patcher}"
  local -r FileDescription="${4:-patch update file}"
  local -r FileName="${5:-}"
  local -r DirectoryDescription="${6:-home directory of the patcher}"
  local -r DirectoryName="${7:-}"
  local -r Marker="${8:-}"
  local -i Retcode=$RETCODE_SUCCESS

#echo '-------------'
#echo 'UpdatePatcher'
#echo '-------------'
#echo "PatcherDescription:   ${PatcherDescription}"
#echo "FileDescription:      ${FileDescription}"
#echo "FileName:             ${FileName}"
#echo "DirectoryDescription: ${DirectoryDescription}"
#echo "DirectoryName:        ${DirectoryName}"
#echo "Marker:               ${Marker}"

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ -n "$FileName" ]] ; then
    local -r BackupDirectoryName="${DirectoryName}-backup"
    local -i bProceed=$VALUE_TRUE
    local -i bMoved=$VALUE_FALSE

    ### Verify whether the package update file has already been updated. ###

    if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ -n "$Marker" ]] ; then
      executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$Marker"
      if [[ 0 -eq $? ]] ; then
        bProceed=$VALUE_FALSE
        echoCommandMessage "the ${FileDescription} has already been updated" "$DirectoryName" "$FileName"
      else
        echoCommandMessage "the ${FileDescription} has not been updated" "$DirectoryName" "$FileName"
      fi
    fi

    ### Rename the original patching utility home to serve as backup. ###

    if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ $VALUE_TRUE -eq $bProceed ]] ; then
      executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'mv' "$DirectoryName" "$BackupDirectoryName"
      processCommandCode $? "failed to move the ${DirectoryDescription}" "$DirectoryName" "$BackupDirectoryName"
      Retcode=$?
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        bMoved=$VALUE_TRUE
      fi
    fi

    ### Extract the package update file to the patching utility home directory. ###

    if [[ $VALUE_TRUE -eq $bProceed ]] ; then
      extractFile $Retcode "$User" "$Group" "$FileDescription" "$FileName" "base directory of the ${PatcherDescription}" "$(dirname ${DirectoryName})"
      createMarker $? "$User" "$Group" "$Marker"
      Retcode=$?
    fi

    ### Restore the original patcher if an error occurred. ###

    if [[ $RETCODE_SUCCESS -ne $Retcode ]] && [[ $VALUE_TRUE -eq $bMoved ]] ; then
      deleteDirectory "$DirectoryDescription" "$DirectoryName" "$User"
      if [[ $RETCODE_SUCCESS -eq $? ]] ; then
        executeCommand 'sudo' 'mv' "$BackupDirectoryName" "$DirectoryName"
        processCommandCode $? "failed to restore the ${DirectoryDescription}" "$BackupDirectoryName" "$DirectoryName"
      fi
    fi
  fi

  return $Retcode
}

################################ Database functions ################################

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
  local PatchesDirectoryName=''
  local InventoryDirectoryName=''
  local User=''
  local Group=''
  local UpgradePatchFileName=''
  local UpgradePatchFileNameDescription=''
  local ResponseFileName=''
  local ResponseFilePermissions=''
  local BaseDirectoryName=''
  local HomeDirectoryName=''
  local DataDirectoryName=''
  local RecoveryDirectoryName=''
  local DatabaseName=''
  local HostName=''
  local DBAGroupName=''
  local Password=''
  local ServiceName=''
  echoTitle "installing the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]}"
  retrieveOption $? "$1" "$2" "$OPTION_PATCHES_DIRECTORY_NAME"                'Message' 'PatchesDirectoryName'
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_INVENTORY_DIRECTORY_NAME" 'Message' 'InventoryDirectoryName'
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_USER"                     'Message' 'User'
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_GROUP"                    'Message' 'Group'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_UPGRADE_PATCH_FILE_NAME"      'Message' 'UpgradePatchFileName' 'UpgradePatchFileNameDescription'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_RESPONSE_FILE_NAME"           'Message' 'ResponseFileName'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_RESPONSE_FILE_PERMISSIONS"    'Message' 'ResponseFilePermissions'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_BASE_DIRECTORY_NAME"          'Message' 'BaseDirectoryName'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_HOME_DIRECTORY_NAME"          'Message' 'HomeDirectoryName'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_DATA_DIRECTORY_NAME"          'Message' 'DataDirectoryName'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_RECOVERY_DIRECTORY_NAME"      'Message' 'RecoveryDirectoryName'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_NAME"                         'Message' 'DatabaseName'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_HOSTNAME"                     'Message' 'HostName'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_ADMINISTRATOR_GROUP_NAME"     'Message' 'DBAGroupName'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_PASSWORD"                     'Message' 'Password'
  retrieveOption $? "$1" "$2" "$OPTION_SYSTEMD_SERVICE_NAME"                  'Message' 'ServiceName'
  local -i Retcode=$?
  local -r InventoryInstaller="${InventoryDirectoryName}/orainstRoot.sh"
  local -r InventoryInstallerDescription='Oracle Inventory root installer program'
  local -r DatabaseInstaller="${HomeDirectoryName}/runInstaller"
  local -r DatabaseInstallerDescription="${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} installer program"
  local -r DatabaseRootInstaller="${HomeDirectoryName}/root.sh"
  local -r DatabaseRootInstallerDescription="${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} root installer program"
  local -r MarkerProvisioned="${HomeDirectoryName}/${INSTALLATION_STEP_PROVISIONED}"
  local -r MarkerInstalled="${HomeDirectoryName}/${INSTALLATION_STEP_INSTALLED}"
  local -r MarkerConfigured="${HomeDirectoryName}/${INSTALLATION_STEP_CONFIGURED}"
  local -r MarkerPrepared="${HomeDirectoryName}/${INSTALLATION_STEP_PREPARED}"
  local -r MarkerInventoryConfigured="${HomeDirectoryName}/${INSTALLATION_STEP_CONFIGURED}_INVENTORY"
  local -r MarkerRootConfigured="${HomeDirectoryName}/${INSTALLATION_STEP_CONFIGURED}_ROOT"
  local -r MarkerOratabModified="${HomeDirectoryName}/${INSTALLATION_STEP_MODIFIED}_ORATAB"
  local -i bResponseCreated=$VALUE_FALSE
  local PatchNumber=''

  if [[ $RETCODE_SUCCESS -ne $Retcode ]] ; then
    echo "$Message"
  else
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$MarkerProvisioned"
    processCommandCode $? "the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} software is not provisioned" "$HomeDirectoryName"
    Retcode=$?
  fi

  ###########################################################################
  # Generation of the Oracle Database automated installation response file. #
  ###########################################################################

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoSection "generation of the ${DESCRIPTION_DATABASE_RESPONSE_FILE}"
  fi

  ### Generate the response file. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$MarkerInstalled" '-a' '-f' "$MarkerConfigured"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} is already installed and configured" "$HomeDirectoryName"
    else
      echoCommandMessage "the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} has not been installed and configured"
      echoInfo "a ${DESCRIPTION_DATABASE_RESPONSE_FILE} will be generated" "$ResponseFileName"
      local FileContent=''
      read -d '' FileContent <<EOF
oracle.install.responseFileVersion=/oracle/install/rspfmt_dbinstall_response_schema_v19.0.0
oracle.install.option=INSTALL_DB_AND_CONFIG
# SELECTED_LANGUAGES=en
UNIX_GROUP_NAME=${Group}
INVENTORY_LOCATION=${InventoryDirectoryName}
ORACLE_HOME=${HomeDirectoryName}
ORACLE_BASE=${BaseDirectoryName}
ORACLE_HOSTNAME=${HostName}
SECURITY_UPDATES_VIA_MYORACLESUPPORT=false
DECLINE_SECURITY_UPDATES=true
oracle.install.db.InstallEdition=EE
oracle.install.db.OSDBA_GROUP=${DBAGroupName}
oracle.install.db.OSBACKUPDBA_GROUP=${DBAGroupName}
oracle.install.db.OSDGDBA_GROUP=${DBAGroupName}
oracle.install.db.OSKMDBA_GROUP=${DBAGroupName}
oracle.install.db.OSRACDBA_GROUP=${DBAGroupName}
oracle.install.db.rootconfig.executeRootScript=false
oracle.install.db.config.starterdb.type=GENERAL_PURPOSE
oracle.install.db.config.starterdb.globalDBName=${DatabaseName}
oracle.install.db.config.starterdb.SID=${DatabaseName}
oracle.install.db.ConfigureAsContainerDB=false
oracle.install.db.config.starterdb.characterSet=AL32UTF8
oracle.install.db.config.starterdb.memoryOption=false
oracle.install.db.config.starterdb.memoryLimit=8192
oracle.install.db.config.starterdb.installExampleSchemas=false
oracle.install.db.config.starterdb.password.ALL=${Password}
oracle.install.db.config.starterdb.managementOption=DEFAULT
oracle.install.db.config.starterdb.enableRecovery=true
oracle.install.db.config.starterdb.storageType=FILE_SYSTEM_STORAGE
oracle.install.db.config.starterdb.fileSystemStorage.dataLocation=${DataDirectoryName}
oracle.install.db.config.starterdb.fileSystemStorage.recoveryLocation=${RecoveryDirectoryName}
EOF
      local -r FileContent
      createFile $Retcode "$User" "$Group" "$ResponseFilePermissions" "$DESCRIPTION_DATABASE_RESPONSE_FILE" "$ResponseFileName" 'FileContent' $VALUE_TRUE 'bResponseCreated'
      Retcode=$?
    fi
  fi

  ########################################
  # Installation of the Oracle Database. #
  ########################################

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoSection "installation of the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]}"
  fi

  ### Change the current working directory to the Oracle Database home directory. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    if [[ ! -d "$HomeDirectoryName" ]] || [[ ! -x "$HomeDirectoryName" ]] ; then
      echoError $RETCODE_OPERATION_ERROR "the ${DESCRIPTION_DATABASE_HOME_DIRECTORY} does not exist or is inaccessible" "$HomeDirectoryName"
    else
      echoCommand 'cd' "$HomeDirectoryName"
      cd "$HomeDirectoryName"
      processCommandCode $? "failed to change the current working directory to the ${DESCRIPTION_DATABASE_HOME_DIRECTORY}" "$HomeDirectoryName"
    fi
    Retcode=$?
  fi

  ### Export the ORACLE_HOME environment variable. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoCommand 'export' "ORACLE_HOME=${HomeDirectoryName}"
    export ORACLE_HOME="$HomeDirectoryName"
    processCommandCode $? "failed to export the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} environment variable ORACLE_HOME" "$HomeDirectoryName"
    Retcode=$?
  fi

  ### Export the LD_LIBRARY_PATH environment variable. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoCommand 'export' "LD_LIBRARY_PATH=${HomeDirectoryName}/lib:${LD_LIBRARY_PATH}"
    export LD_LIBRARY_PATH="${HomeDirectoryName}/lib:${LD_LIBRARY_PATH}"
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
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$MarkerInstalled"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} is already installed" "$HomeDirectoryName"
    else
      echoCommandMessage "the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} has not been installed" "$HomeDirectoryName"
      if [[ -n "$UpgradePatchFileName" ]] ; then
        determinePatchNumber 'PatchNumber' "$UpgradePatchFileName" "$UpgradePatchFileNameDescription"
        Retcode=$?
      fi
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        echoInfo "installing the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} with a ${DESCRIPTION_DATABASE_RESPONSE_FILE}" "$ResponseFileName"
        if [[ -n "$PatchNumber" ]] ; then
          executeCommand 'sudo' '-E' '-u' "$User" '-g' "$Group" "${DatabaseInstaller}" '-silent' '-responseFile' "$ResponseFileName" '-applyRU' "${PatchesDirectoryName}/${PatchNumber}"
        else
          executeCommand 'sudo' '-E' '-u' "$User" '-g' "$Group" "${DatabaseInstaller}" '-silent' '-responseFile' "$ResponseFileName"
        fi
        processCommandCode $? "an error occurred when running the ${DatabaseInstallerDescription}" "$DatabaseInstaller"
        Retcode=$?
        if [[ -n "$PatchNumber" ]] ; then
          createMarker $Retcode "$User" "$Group" "${HomeDirectoryName}/${INSTALLATION_STEP_PATCHED}_${PatchNumber}"
          Retcode=$?
        fi
        createMarker $Retcode "$User" "$Group" "$MarkerInstalled"
        Retcode=$?
      fi
    fi
  fi

  ########################################
  # Perform the post-installation steps. #
  ########################################

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoSection "post-installation steps"
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

  ### Configure the Oracle Database. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$MarkerConfigured"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} is already configured" "$HomeDirectoryName"
    else
      echoCommandMessage "the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} has not been configured" "$HomeDirectoryName"
      executeCommand 'sudo' '-E' '-u' "$User" "$DatabaseInstaller" '-executeConfigTools' '-silent' '-responseFile' "$ResponseFileName"
      processCommandCode $? "an error occurred when running the ${DatabaseInstallerDescription}" "${DatabaseInstaller} -executeConfigTools"
      createMarker $? "$User" "$Group" "$MarkerConfigured"
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
      echoCommandMessage "the automatic start of the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} is already enabled" "$ORATAB_FILE_NAME"
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

  #######################################
  # Preparation of the Oracle Database. #
  #######################################

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoSection "preparation of the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]}"
  fi

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$MarkerPrepared"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} is already prepared" "$DatabaseName"
      Retcode=$?
    else
      echoCommandMessage "the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} has not been prepared" "$DatabaseName"

      ### Change the current working directory to the Oracle Database home directory. ###

      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        echoCommand 'cd' "$HomeDirectoryName"
        cd "$HomeDirectoryName"
        processCommandCode $? "failed to change the current working directory to the ${DESCRIPTION_DATABASE_HOME_DIRECTORY}" "$HomeDirectoryName"
        Retcode=$?
      fi

      ### Export the ORACLE_HOME environment variable. ###

      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        echoCommand 'export' "ORACLE_HOME=${HomeDirectoryName}"
        export ORACLE_HOME="$HomeDirectoryName"
        processCommandCode $? "failed to export the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} environment variable ORACLE_HOME" "$HomeDirectoryName"
        Retcode=$?
      fi

      ### Configure the Oracle Database parameters required by Oracle Enterprise Manager. ###

      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'sudo' '-E' '-u' "$User" '-g' "$Group" "${HomeDirectoryName}/bin/sqlplus" '/nolog' <<EOF
CONNECT sys/${Password}@${DatabaseName} AS sysdba
ALTER SYSTEM SET "_allow_insert_with_update_check"=true scope=both;
ALTER SYSTEM SET session_cached_cursors=200 scope=spfile;
ALTER SYSTEM SET shared_pool_size=600M scope=spfile;
ALTER SYSTEM SET processes=600 scope=spfile;
ALTER DATABASE ADD LOGFILE GROUP 4('${DataDirectoryName}/redo04.log') SIZE 2G;
ALTER DATABASE ADD LOGFILE GROUP 5('${DataDirectoryName}/redo05.log') SIZE 2G;
ALTER DATABASE ADD LOGFILE GROUP 6('${DataDirectoryName}/redo06.log') SIZE 2G;
ALTER SYSTEM CHECKPOINT;
ALTER DATABASE DROP LOGFILE GROUP 2;
ALTER DATABASE DROP LOGFILE GROUP 3;
ALTER SYSTEM SWITCH LOGFILE;
ALTER DATABASE DROP LOGFILE GROUP 1;
SHUTDOWN TRANSACTIONAL
EOF
        processCommandCode $? "failed to configure the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} parameters" "$DatabaseName"
        Retcode=$?
      fi

      ### Restart the Oracle Database. ###

      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'sudo' 'systemctl' 'stop' "$ServiceName"
        processCommandCode $? "failed to stop the ${DESCRIPTION_SYSTEMD_SERVICE}" "$ServiceName"
        Retcode=$?
      fi

      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'sudo' 'systemctl' 'start' "$ServiceName"
        processCommandCode $? "failed to start the ${DESCRIPTION_SYSTEMD_SERVICE}" "$ServiceName"
        Retcode=$?
      fi

      ### Create indicator that the Oracle Database has been configured. ###

      createMarker $Retcode "$User" "$Group" "$MarkerPrepared"
      Retcode=$?
    fi
  fi

  return $Retcode
}

################################################################################
## @fn provisionDatabase
##
## @brief Provision the Oracle Database software.
##
## @param[in] Sources The name of the variable that contains the sources of the
##                    program option values.
## @param[in] Values  The name of the vatiable that contains the program option
##                    values.
##
## @note This function performs the following steps:
##
## @li Extraction of the Oracle Enterprise Manager package files to a temporary
##     staging location called repository.
## @li Extraction of the Oracle OPatch utility update, if provided, to the
##     sub-directory OPatch in the Oracle Database home directory.
## @li Extraction of the patch package files, if any provided, to the staging
##     location.
##
## @return The return code of the function execution.
################################################################################
provisionDatabase() {
  local Message=''
  local PatchesDirectoryName=''
  local User=''
  local Group=''
  local PackageFileName=''
  local OPatchFileName=''
  local OPatchFileNameDescription=''
  local UpgradePatchFileName=''
  local UpgradePatchFileNameDescription=''
  local HomeDirectoryName=''
  echoTitle "provisioning the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} software"
  retrieveOption $? "$1" "$2" "$OPTION_PATCHES_DIRECTORY_NAME"           'Message' 'PatchesDirectoryName'
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_USER"                'Message' 'User'
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_GROUP"               'Message' 'Group'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_PACKAGE_FILE_NAME"       'Message' 'PackageFileName'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_OPATCH_FILE_NAME"        'Message' 'OPatchFileName' 'OPatchFileNameDescription'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_UPGRADE_PATCH_FILE_NAME" 'Message' 'UpgradePatchFileName' 'UpgradePatchFileNameDescription'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_HOME_DIRECTORY_NAME"     'Message' 'HomeDirectoryName'
  local -i Retcode=$?
  local -r MarkerProvisioned="${HomeDirectoryName}/${INSTALLATION_STEP_PROVISIONED}"
  local -r MarkerInstalled="${HomeDirectoryName}/${INSTALLATION_STEP_INSTALLED}"
  local PatchNumber=''

  if [[ $RETCODE_SUCCESS -ne $Retcode ]] ; then
    echo "$Message"
  fi

  ############################################
  # Extraction the Oracle Database software. #
  ############################################

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoSection "extraction of the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} software"
  fi

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$MarkerProvisioned" '-o' '-f' "$MarkerInstalled"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${DESCRIPTION_DATABASE_PACKAGE_FILE} has already been provisioned or installed" "$HomeDirectoryName" "$PackageFileName"
      Retcode=$?
    else
      echoCommandMessage "the ${DESCRIPTION_DATABASE_PACKAGE_FILE} has not been provisioned" "$HomeDirectoryName" "$PackageFileName"

      ### Validate that the Oracle Database home directory can be written. ###

      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-d' "$HomeDirectoryName" '-a' '-w' "$HomeDirectoryName"
        processCommandCode $? "the ${DESCRIPTION_DATABASE_HOME_DIRECTORY} does not exist, is inaccessible, or is not writable" "$HomeDirectoryName"
        Retcode=$?
      fi

      ### Validate that the Oracle Database package file can be read. ###

      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'sudo' 'test' '-f' "$PackageFileName" '-a' '-r' "$PackageFileName"
        processCommandCode $? "the ${DESCRIPTION_DATABASE_PACKAGE_FILE} does not exist, is inaccessible, or cannot be read" "$PackageFileName"
        Retcode=$?
      fi

      ### Extract the Oracle Database package file to the Oracle Database home directory. ###

      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'sudo' 'unzip' '-d' "$HomeDirectoryName" "$PackageFileName"
        processCommandCode $? "failed to extract the ${DESCRIPTION_DATABASE_PACKAGE_FILE}" "$PackageFileName" "${HomeDirectoryName}"
        setDirectoryAttributes $? "$User" "$Group" "$DESCRIPTION_DATABASE_HOME_DIRECTORY" "$HomeDirectoryName"
        createMarker $? "$User" "$Group" "$MarkerProvisioned"
        Retcode=$?
      fi
    fi
  fi

  #################################################
  # Update of the Oracle Database OPatch utility. #
  #################################################

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ -n "$OPatchFileName" ]] ; then
    local -r OPatchHomeDirectoryName="${HomeDirectoryName}/OPatch"
    echoSection "update the ${DESCRIPTION_DATABASE_OPATCH}" "$OPatchFileName" "$OPatchHomeDirectoryName"
    determinePatchNumber 'PatchNumber' "$OPatchFileName" "$OPatchFileNameDescription"
    Retcode=$?
    if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ -n "$PatchNumber" ]] ; then
      updatePatcher \
        "$User" \
        "$Group" \
        "$DESCRIPTION_DATABASE_OPATCH" \
        "$DESCRIPTION_DATABASE_OPATCH_FILE" \
        "$OPatchFileName" \
        "$DESCRIPTION_DATABASE_OPATCH_HOME" \
        "$OPatchHomeDirectoryName" \
        "${HomeDirectoryName}/${INSTALLATION_STEP_PATCHED}_${PatchNumber}"
      Retcode=$?
    fi
  fi

  ####################################################
  # Extraction of the Oracle Database upgrade patch. #
  ####################################################

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ -n "$UpgradePatchFileName" ]] ; then
    echoSection "extract the ${DESCRIPTION_DATABASE_UPGRADE_PATCH}" "$UpgradePatchFileName" "$PatchesDirectoryName"
    extractPatch \
      "$User" \
      "$Group" \
      "$DESCRIPTION_DATABASE_UPGRADE_PATCH" \
      "$DESCRIPTION_DATABASE_UPGRADE_PATCH_FILE" \
      "$UpgradePatchFileName" \
      "$UpgradePatchFileNameDescription" \
      "$DESCRIPTION_PATCHES_DIRECTORY" \
      "$PatchesDirectoryName"
    Retcode=$?
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
  local BaseDirectoryName
  local HomeDirectoryName
  echoTitle "de-installing the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]}"
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_USER"            'Message' 'User'
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_GROUP"           'Message' 'Group'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_BASE_DIRECTORY_NAME" 'Message' 'BaseDirectoryName'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_HOME_DIRECTORY_NAME" 'Message' 'HomeDirectoryName'
  local -i Retcode=$?
  local -r Deinstaller="${HomeDirectoryName}/deinstall/deinstall"
  local -r DeinstallerDescription="${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} de-installer program"
  local ResponseFileName=''
  local -r ResponseFileNameDescription="${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} de-installation response file"
  local -r MarkerProvisioned="${HomeDirectoryName}/${INSTALLATION_STEP_PROVISIONED}"
  local -r MarkerInstalled="${HomeDirectoryName}/${INSTALLATION_STEP_INSTALLED}"
  local -i bProceed=$VALUE_FALSE

  if [[ $RETCODE_SUCCESS -ne $Retcode ]] ; then
    echo "$Message"
    return $Retcode
  fi

  ### Validate that the Oracle Enterprise Manager is installed in the provided home directory. ###

  executeCommand 'sudo' 'test' '-d' "$HomeDirectoryName"
  if [[ 0 -eq $? ]] ; then
    echoCommandMessage "the ${DESCRIPTION_DATABASE_HOME_DIRECTORY} exists" "$HomeDirectoryName"
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$MarkerProvisioned"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} software is provisioned" "$HomeDirectoryName"
      executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$MarkerInstalled"
      if [[ 0 -eq $? ]] ; then
        echoCommandMessage "the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} software is installed" "$HomeDirectoryName"
        bProceed=$VALUE_TRUE
      else
        echoCommandMessage "the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} software has not been installed" "$HomeDirectoryName"
      fi
    else
      echoCommandMessage "the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} software has not been provisioned" "$HomeDirectoryName"
    fi
  else
    echoCommandMessage "the ${DESCRIPTION_DATABASE_HOME_DIRECTORY} does not exist" "$HomeDirectoryName"
  fi

  ###########################################################
  # Preparation for de-installation of the Oracle Database. #
  ###########################################################

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ $VALUE_TRUE -eq $bProceed ]] ; then
    echoSection "preparation for de-installation of the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]}"
  fi

  ### Validate that the Oracle Database de-installer is present and usable by the installation user. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ $VALUE_TRUE -eq $bProceed ]] ; then
    executeCommand 'sudo' '-u' "$User" -g "$Group" 'test' '-x' "$Deinstaller"
    processCommandCode $? "the ${DeinstallerDescription} does not exist or is inaccessible" "$Deinstaller"
    Retcode=$?
  fi

  ### Export the CV_ASSUME_DISTID environment variable to enable de-installation of the Oracle databse. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ $VALUE_TRUE -eq $bProceed ]] ; then
    local -r CV_ASSUME_DISTID_VALUE='OL7'
    echoCommand 'export' "CV_ASSUME_DISTID=${CV_ASSUME_DISTID_VALUE}"
    export CV_ASSUME_DISTID="$CV_ASSUME_DISTID_VALUE"
    processCommandCode $? "failed to export the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} environment variable CV_ASSUME_DISTID" "$CV_ASSUME_DISTID_VALUE"
    Retcode=$?
  fi

  ### Generate the automated de-installation response file. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ $VALUE_TRUE -eq $bProceed ]] ; then
    local Line=''
    local Left=''
    local Right=''
    local Error=''
    echoCommand 'sudo' '-E' '-u' "$User" '-g' "$Group" "$Deinstaller" '-silent' '-checkonly'
    while IFS= read -r Line ; do
      if [[ -z "$Error" ]] && [[ -z "$Right" ]] ; then
        Left=$(echo "$Line" | awk -F ':' '{ print $1 }')
        if [[ 'ERROR' == "$Left" ]] ; then
          Right=$(echo "$Line" | awk -F ':' '{ print $2 }')
          Error=$(echo "$Right" | awk '{$1=$1};1')
        elif [[ 'Location of response file generated' == "$Left" ]] ; then
          Right=$(echo "$Line" | awk -F ':' '{ print $2 }')
          ResponseFileName=$(echo "$Right" | awk -F "$CHARACTER_SINGLE_QUOTE" '{ print $2 }')
        else
          Left=''
        fi
      fi
    done < <(sudo -E -u "$User" -g "$Group" "$Deinstaller" -silent -checkonly)
    Retcode=$?
    if [[ 0 -eq $Retcode ]] && [[ -z "$ResponseFileName" ]] ; then
      Retcode=1
    fi
    if [[ 0 -eq $Retcode ]] ; then
      echoCommandMessage "$ResponseFileNameDescription" "$ResponseFileName"
    elif [[ -n "$Error" ]] ; then
      processCommandCode $Retcode "an error occurred during the execution of the ${DeinstallerDescription}" "$Deinstaller" "$Error"
    elif [[ -n "$Right" ]] ; then
      processCommandCode $Retcode "failed to obtain a ${ResponseFileNameDescription} from the ${DeinstallerDescription}" "$Deinstaller"
    else
      processCommandCode $Retcode "failed to generate a ${ResponseFileNameDescription} with the ${DeinstallerDescription}" "$Deinstaller"
    fi
    Retcode=$?
  fi

  ### Validate that the automated de-installation response file is present and accessible to the installation user. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ $VALUE_TRUE -eq $bProceed ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-r' "$ResponseFileName"
    processCommandCode $? "the ${ResponseFileNameDescription} does not exist or is inaccessible" "$ResponseFileName"
    Retcode=$?
  fi

  ###########################################
  # De-installation of the Oracle Database. #
  ###########################################

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ $VALUE_TRUE -eq $bProceed ]] ; then
    echoSection "de-installation of the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]}"
    executeCommand 'sudo' '-E' '-u' "$User" '-g' "$Group" "$Deinstaller" '-silent' '-paramfile' "$ResponseFileName"
    processCommandCode $? "an error occurred when running the ${DeinstallerDescription}" "$Deinstaller" "$ResponseFileName"
    Retcode=$?
  fi

  #############
  # Clean-up. #
  #############

  echoSection 'Clean-up'

  ### Delete the Oracle Database base directory. ###

  if [[ $VALUE_FALSE -eq $bProceed ]] ; then
    echoInfo "deleting the installation directories instead"
    deleteDirectory "$DESCRIPTION_DATABASE_BASE_DIRECTORY" "$BaseDirectoryName" "$User"
  fi

  ### Delete any remaining files. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    deleteFile "${DESCRIPTION_DATABASE_HOME_DIRECTORY} environment selector" '/usr/local/bin/dbhome'
    deleteFile "C Shell environment conditioner for the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]}" '/usr/local/bin/coraenv'
    deleteFile "Bourne Shell environment conditioner for the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]}" '/usr/local/bin/oraenv'
    deleteFile 'oratab file' "$ORATAB_FILE_NAME"
    deleteFile 'Oracle installation inventory pointer file' '/etc/oraInst.loc'
    deleteDirectory "${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]} file mapping" '/opt/ORCLfmap'
  fi

  return $Retcode
}

################################ Oracle Enterprise Manager functions ################################

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
  local StagingDirectoryName=''
  local PatchesDirectoryName=''
  local InventoryDirectoryName=''
  local User=''
  local Group=''
  local HostName=''
  local DatabaseData=''
  local DatabaseName=''
  local DatabaseHostName=''
  local DatabasePort=''
  local DatabasePassword=''
  local Version=''
  local UpgradePatchFileName=''
  local UpgradePatchFileNameDescription=''
  local PatchesFileNames=''
  local PatchesFileNamesDescription=''
  local ResponseFileName=''
  local ResponseFilePermissions=''
  local BaseDirectoryName=''
  local HomeDirectoryName=''
  local InstanceDirectoryName=''
  local UserPort=''
  local UserPortDescription=''
  local UploadPort=''
  local UploadPortDescription=''
  local ManagerPassword=''
  local KeystoreFileName=''
  local KeystorePassword=''
  local TruststoreFileName=''
  local TruststorePassword=''
  local AgentBaseDirectoryName=''
  local AgentHomeDirectoryName=''
  local AgentInstanceDirectoryName=''
  local AgentPort=''
  local AgentPortDescription=''
  local AgentPassword=''
  local WeblogicPort=''
  local WeblogicPortDescription=''
  local WeblogicUser=''
  local WeblogicPassword=''
  echoTitle "installing the ${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]}"
  retrieveOption $? "$1" "$2" "$OPTION_STAGING_DIRECTORY_NAME"                'Message' 'StagingDirectoryName'
  retrieveOption $? "$1" "$2" "$OPTION_PATCHES_DIRECTORY_NAME"                'Message' 'PatchesDirectoryName'
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_INVENTORY_DIRECTORY_NAME" 'Message' 'InventoryDirectoryName'
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_USER"                     'Message' 'User'
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_GROUP"                    'Message' 'Group'
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_HOSTNAME"                 'Message' 'HostName'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_DATA_DIRECTORY_NAME"          'Message' 'DatabaseData'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_NAME"                         'Message' 'DatabaseName'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_HOSTNAME"                     'Message' 'DatabaseHostName'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_PORT"                         'Message' 'DatabasePort'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_PASSWORD"                     'Message' 'DatabasePassword'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_VERSION"                       'Message' 'Version'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_UPGRADE_PATCH_FILE_NAME"       'Message' 'UpgradePatchFileName' 'UpgradePatchFileNameDescription'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_PATCHES_FILE_NAMES"            'Message' 'PatchesFileNames' 'PatchesFileNamesDescription'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_RESPONSE_FILE_NAME"            'Message' 'ResponseFileName'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_RESPONSE_FILE_PERMISSIONS"     'Message' 'ResponseFilePermissions'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_BASE_DIRECTORY_NAME"           'Message' 'BaseDirectoryName'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_HOME_DIRECTORY_NAME"           'Message' 'HomeDirectoryName'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_INSTANCE_DIRECTORY_NAME"       'Message' 'InstanceDirectoryName'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_USER_PORT"                     'Message' 'UserPort' 'UserPortDescription'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_UPLOAD_PORT"                   'Message' 'UploadPort' 'UploadPortDescription'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_PASSWORD"                      'Message' 'ManagerPassword'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_KEYSTORE_FILE_NAME"            'Message' 'KeystoreFileName'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_KEYSTORE_PASSWORD"             'Message' 'KeystorePassword'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_TRUSTSTORE_FILE_NAME"          'Message' 'TruststoreFileName'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_TRUSTSTORE_PASSWORD"           'Message' 'TruststorePassword'
  retrieveOption $? "$1" "$2" "$OPTION_AGENT_BASE_DIRECTORY_NAME"             'Message' 'AgentBaseDirectoryName'
  retrieveOption $? "$1" "$2" "$OPTION_AGENT_HOME_DIRECTORY_NAME"             'Message' 'AgentHomeDirectoryName'
  retrieveOption $? "$1" "$2" "$OPTION_AGENT_INSTANCE_DIRECTORY_NAME"         'Message' 'AgentInstanceDirectoryName'
  retrieveOption $? "$1" "$2" "$OPTION_AGENT_PORT"                            'Message' 'AgentPort' 'AgentPortDescription'
  retrieveOption $? "$1" "$2" "$OPTION_AGENT_PASSWORD"                        'Message' 'AgentPassword'
  retrieveOption $? "$1" "$2" "$OPTION_WEBLOGIC_PORT"                         'Message' 'WeblogicPort' 'WeblogicPortDescription'
  retrieveOption $? "$1" "$2" "$OPTION_WEBLOGIC_USER"                         'Message' 'WeblogicUser'
  retrieveOption $? "$1" "$2" "$OPTION_WEBLOGIC_PASSWORD"                     'Message' 'WeblogicPassword'
  local -i Retcode=$?
  local -r Installer="${HomeDirectoryName}/sysman/install/ConfigureGC.sh"
  local -r InstallerDescription="configuration program for the ${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]}"
  local -r AgentInstaller="${AgentHomeDirectoryName}/sysman/install/agentDeploy.sh"
  local -r AgentInstallerDescription="installer program for the ${PRODUCT_DESCRIPTIONS[${PRODUCT_AGENT}]}"
  local -r MarkerProvisioned="${HomeDirectoryName}/${INSTALLATION_STEP_PROVISIONED}"
  local -r MarkerAgentProvisioned="${AgentHomeDirectoryName}/${INSTALLATION_STEP_PROVISIONED}"
  local -r MarkerInstalled="${HomeDirectoryName}/${INSTALLATION_STEP_INSTALLED}"
  local -r MarkerAgentInstalled="${AgentHomeDirectoryName}/${INSTALLATION_STEP_INSTALLED}"
  local -r MarkerFirewalldConfigured="${HomeDirectoryName}/${INSTALLATION_STEP_CONFIGURED}_FIREWALLD"
  local -r MarkerPatched="${HomeDirectoryName}/${INSTALLATION_STEP_PATCHED}"
  local -i bResponseCreated=$VALUE_FALSE
  local -a FileNames
  local FileName=''

  if [[ $RETCODE_SUCCESS -ne $Retcode ]] ; then
    echo "$Message"
  else
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$MarkerProvisioned"
    processCommandCode $? "the ${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} software is not provisioned" "$HomeDirectoryName"
    Retcode=$?
  fi

  ###############################
  # Application of the patches. #
  ###############################

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoSection "Application of the patches"
  fi

  ### Export the ORACLE_HOME environment variable. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoCommand 'export' "ORACLE_HOME=${HomeDirectoryName}"
    export ORACLE_HOME="$HomeDirectoryName"
    processCommandCode $? 'failed to export the environment variable ORACLE_HOME' "$HomeDirectoryName"
    Retcode=$?
  fi

  ### Patch the Oracle Enterprise Manager. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ -n "$PatchesFileNames" ]] ; then
    FileNames=()
    if [[ 0 -eq $Retcode ]] ; then
      echoCommand "IFS=',' read -ra <<< ${PatchesFileNames}"
      IFS=',' read -ra FileNames <<< "$PatchesFileNames"
      processCommandCode $? "failed to read ${PatchesFileNamesDescription}" "$OPTION_MANAGER_PACKAGES_FILE_NAMES"
      Retcode=$?
    fi
    for FileName in ${FileNames[@]} ; do
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        applyPatch "$User" "$Group" "$DESCRIPTION_MANAGER_PATCH" "$OPTION_MANAGER_PACKAGES_FILE_NAME" "$FileName" "$FileNameDescription" "$DESCRIPTION_PATCHES_DIRECTORY" "$PatchesDirectoryName" "$HomeDirectoryName" "$MarkerPatched"
        Retcode=$?
      fi
    done
  fi

  ### Upgrade the Oracle Enterprise Manager. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ -n "$UpgradePatchFileName" ]] ; then
    applyPatch "$User" "$Group" "$DESCRIPTION_MANAGER_PATCH" "$DESCRIPTION_MANAGER_UPGRADE_PATCH" "$UpgradePatchFileName" "$UpgradePatchFileNameDescription" "$DESCRIPTION_PATCHES_DIRECTORY" "$PatchesDirectoryName" "$HomeDirectoryName" "$MarkerPatched"
    Retcode=$?
  fi

return $Retcode

  ##################################################
  # Installation of the Oracle Enterprise Manager. #
  ##################################################

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoSection "installation of the ${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]}"
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$MarkerInstalled"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} is already installed" "$HomeDirectoryName"
    else
      echoCommandMessage "the ${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} has not been installed"

      ### Generate the response file. ###

      echoInfo "a ${DESCRIPTION_MANAGER_RESPONSE_FILE} will be generated" "$ResponseFileName"
      local FileContent=''
      read -d '' FileContent <<EOF
RESPONSEFILE_VERSION=2.2.1.0.0
UNIX_GROUP_NAME=${Group}
INVENTORY_LOCATION=${InventoryDirectoryName}
# Installation
CONFIGURATION_TYPE=ADVANCED
b_upgrade=false
INSTALL_UPDATES_SELECTION=skip
EM_INSTALL_TYPE=NOSEED
EMPREREQ_AUTO_CORRECTION=true
CONFIGURE_ORACLE_SOFTWARE_LIBRARY=true
SOFTWARE_LIBRARY_LOCATION=${BaseDirectoryName}/software
# Weblogic
ORACLE_MIDDLEWARE_HOME_LOCATION=${HomeDirectoryName}
ORACLE_HOSTNAME=${HostName}
WLS_ADMIN_SERVER_USERNAME=${WeblogicUser}
WLS_ADMIN_SERVER_PASSWORD=${WeblogicPassword}
WLS_ADMIN_SERVER_CONFIRM_PASSWORD=${WeblogicPassword}
NODE_MANAGER_PASSWORD=${WeblogicPassword}
NODE_MANAGER_CONFIRM_PASSWORD=${WeblogicPassword}
ORACLE_INSTANCE_HOME_LOCATION=${InstanceDirectoryName}
# Repository
DATABASE_HOSTNAME=${DatabaseHostName}
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
AGENT_BASE_DIR=${AgentBaseDirectoryName}
AGENT_REGISTRATION_PASSWORD=${AgentPassword}
AGENT_REGISTRATION_CONFIRM_PASSWORD=${AgentPassword}
# TLS
Is_oneWaySSL=false
Is_twoWaySSL=true
TRUSTSTORE_PASSWORD=${TruststorePassword}
TRUSTSTORE_LOCATION=${TruststoreFileName}
KEYSTORE_PASSWORD=${KeystorePassword}
KEYSTORE_LOCATION=${KeystoreFileName}
EOF
      local -r FileContent
      createFile $Retcode "$User" "$Group" "$ResponseFilePermissions" "$DESCRIPTION_MANAGER_RESPONSE_FILE" "$ResponseFileName" 'FileContent' $VALUE_TRUE 'bResponseCreated'
      Retcode=$?

      ### Export the ORACLE_HOME environment variable. ###

      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        echoCommand 'export' "ORACLE_HOME=${HomeDirectoryName}"
        export ORACLE_HOME="$HomeDirectoryName"
        processCommandCode $? 'failed to export the environment variable ORACLE_HOME' "$HomeDirectoryName"
        Retcode=$?
      fi

      ### Export the OMS_INSTANCE_HOME environment variable. ###

      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        echoCommand 'export' "OMS_INSTANCE_HOME=${InstanceDirectoryName}"
        export OMS_INSTANCE_HOME="$InstanceDirectoryName"
        processCommandCode $? 'failed to export the environment variable OMS_INSTANCE_HOME' "$InstanceDirectoryName"
        Retcode=$?
      fi

      ### Change the current working directory to the Oracle Enterprise Manager home directory. ###

      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        if [[ ! -d "$HomeDirectoryName" ]] || [[ ! -x "$HomeDirectoryName" ]] ; then
          echoError $RETCODE_OPERATION_ERROR "the ${DESCRIPTION_MANAGER_HOME_DIRECTORY} does not exist or is inaccessible" "$HomeDirectoryName"
        else
          echoCommand 'cd' "$HomeDirectoryName"
          cd "$HomeDirectoryName"
          processCommandCode $? "failed to change the current working directory to the ${DESCRIPTION_MANAGER_HOME_DIRECTORY}" "$HomeDirectoryName"
        fi
        Retcode=$?
      fi

      ### Install the Oracle Enterprise Manager. ###

      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'sudo' '-E' '-u' "$User" '-g' "$Group" "$Installer" '-silent' '-responseFile' "$ResponseFileName"
        processCommandCode $? "an error occurred while running the ${InstallerDescription}" "$Installer"
        createMarker $? "$User" "$Group" "$MarkerInstalled"
        Retcode=$?
      fi
    fi
  fi

  ########################################################
  # Installation of the Oracle Enterprise Manager Agent. #
  ########################################################

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$MarkerAgentProvisioned"
    processCommandCode $? "the ${PRODUCT_DESCRIPTIONS[${PRODUCT_AGENT}]} software is not provisioned" "$AgentHomeDirectoryName"
    Retcode=$?
  fi

#  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
#    echoSection "installation of the ${PRODUCT_DESCRIPTIONS[${PRODUCT_AGENT}]}"
#    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$MarkerAgentInstalled"
#    if [[ 0 -eq $? ]] ; then
#      echoCommandMessage "the ${PRODUCT_DESCRIPTIONS[${PRODUCT_AGENT}]} is already installed" "$AgentHomeDirectoryName"
#    else
#      echoCommandMessage "the ${PRODUCT_DESCRIPTIONS[${PRODUCT_AGENT}]} has not been installed" "$AgentHomeDirectoryName"
#      executeCommand 'sudo' '-u' "$User" '-g' "$Group" ${AgentInstaller} \
#        '-ignorePrereqs' \
#        "ORACLE_HOSTNAME=${HostName}" \
#        "AGENT_BASE_DIR=${AgentBaseDirectoryName}" \
#        "AGENT_INSTANCE_HOME=${AgentInstanceDirectoryName}" \
#        "AGENT_PORT=${AgentPort}" \
#        "AGENT_REGISTRATION_PASSWORD=${AgentPassword}" \
#        "OMS_HOST=${HostName}" \
#        "EM_UPLOAD_PORT=${UploadPort}" \
#        'START_AGENT=true' \
#        "SCRATCHPATH=${StagingDirectoryName}" \
#        "PROPERTIES_FILE=''" \
#        'b_doDiscovery=true'
#      processCommandCode $? "an error occurred while running the ${AgentInstallerDescription}" "$AgentInstaller"
#      createMarker $? "$User" "$Group" "$MarkerAgentInstalled"
#      Retcode=$?
#    fi
#  fi

  ########################################
  # Perform the post-installation steps. #
  ########################################

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoSection "post-installation steps"
  fi

  ### Delete the Oracle Enterprise Manager automated installation response file. ###

  if [[ $VALUE_TRUE -eq $bResponseCreated ]] ; then
    deleteFile "$DESCRIPTION_MANAGER_RESPONSE_FILE" "$ResponseFileName" "$User"
  fi

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
          executeCommand 'sudo' 'firewall-cmd' '--permanent' '--zone=public' "--add-port=${UserPort}/tcp"
          processCommandCode $? "failed to allow public access to the ${UserPortDescription}" "$UserPort"
          Retcode=$?
        fi
        if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
          executeCommand 'sudo' 'firewall-cmd' '--permanent' '--zone=public' "--add-port=${UploadPort}/tcp"
          processCommandCode $? "failed to allow public access to the ${UploadPortDescription}" "$UploadPort"
          Retcode=$?
        fi
        if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
          executeCommand 'sudo' 'firewall-cmd' '--permanent' '--zone=public' "--add-port=${AgentPort}/tcp"
          processCommandCode $? "failed to allow public access to the ${AgentPortDescription}" "$AgentPort"
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
## @fn provisionManager
##
## @brief Provision the Oracle Enterprise Manager software.
##
## @param[in] Sources The name of the variable that contains the sources of the
##                    program option values.
## @param[in] Values  The name of the vatiable that contains the program option
##                    values.
##
## @note This function performs the following steps:
##
## @li Extraction of the Oracle Enterprise Manager package files to a temporary
##     staging location called repository.
## @li Extraction of the patch package files, if any provided, to the staging
##     location.
## @li Execution of the installer with option to only extract the software to
##     the Oracle Enterprise Manager home directory.
## @li Execution of the allroot.sh program.
## @li Extraction of the Oracle OPatch utility update, if provided, to the
##     sub-directory OPatch in the Oracle Enterprise Manager home directory.
## @li Extraction of the OMS Patcher utility update, if provided, to the
##     sub-directory OMSPatcher in the Oracle Enterprise Manager home directory.
##
## @return The return code of the function execution.
################################################################################
provisionManager() {
  local Message=''
  local StagingDirectoryName=''
  local PatchesDirectoryName=''
  local InventoryDirectoryName=''
  local User=''
  local Group=''
  local Version=''
  local PackagesFileNames=''
  local PackagesFileNamesDescription=''
  local OPatchFileName=''
  local OPatchFileNameDescription=''
  local OMSPatcherFileName=''
  local OMSPatcherFileNameDescription=''
  local UpgradePatchFileName=''
  local UpgradePatchFileNameDescription=''
  local PatchesFileNames=''
  local PatchesFileNamesDescription=''
  local ResponseFileName=''
  local ResponseFilePermissions=''
  local BaseDirectoryName=''
  local HomeDirectoryName=''
  local AgentBaseDirectoryName=''
  local AgentHomeDirectoryName=''
  echoTitle "provisioning the ${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} software"
  retrieveOption $? "$1" "$2" "$OPTION_STAGING_DIRECTORY_NAME"                'Message' 'StagingDirectoryName'
  retrieveOption $? "$1" "$2" "$OPTION_PATCHES_DIRECTORY_NAME"                'Message' 'PatchesDirectoryName'
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_INVENTORY_DIRECTORY_NAME" 'Message' 'InventoryDirectoryName'
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_USER"                     'Message' 'User'
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_GROUP"                    'Message' 'Group'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_VERSION"                       'Message' 'Version'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_PACKAGES_FILE_NAMES"           'Message' 'PackagesFileNames' 'PackagesFileNamesDescription'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_OPATCH_FILE_NAME"              'Message' 'OPatchFileName' 'OPatchFileNameDescription'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_OMSPATCHER_FILE_NAME"          'Message' 'OMSPatcherFileName' 'OMSPatcherFileNameDescription'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_UPGRADE_PATCH_FILE_NAME"       'Message' 'UpgradePatchFileName' 'UpgradePatchFileNameDescription'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_PATCHES_FILE_NAMES"            'Message' 'PatchesFileNames' 'PatchesFileNamesDescription'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_RESPONSE_FILE_NAME"            'Message' 'ResponseFileName'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_RESPONSE_FILE_PERMISSIONS"     'Message' 'ResponseFilePermissions'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_BASE_DIRECTORY_NAME"           'Message' 'BaseDirectoryName'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_HOME_DIRECTORY_NAME"           'Message' 'HomeDirectoryName'
  retrieveOption $? "$1" "$2" "$OPTION_AGENT_BASE_DIRECTORY_NAME"             'Message' 'AgentBaseDirectoryName'
  retrieveOption $? "$1" "$2" "$OPTION_AGENT_HOME_DIRECTORY_NAME"             'Message' 'AgentHomeDirectoryName'
  local -i Retcode=$?
  local -r Repository="${StagingDirectoryName}/manager-${Version}"
  local -r RepositoryDescription="${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} installation repository directory"
  local -r Extractor="${Repository}/em13500_linux64.bin"
  local -r ExtractorDescription="${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} extraction program"
  local -r RootInstaller="${HomeDirectoryName}/allroot.sh"
  local -r RootInstallerDescription="${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} root installer program"
  local -r InstantClientLibrary="${AgentHomeDirectoryName}/instantclient/libclntshcore.so.12.1"
  local -r MarkerExtracted="${Repository}/${INSTALLATION_STEP_EXTRACTED}"
  local -r MarkerProvisioned="${HomeDirectoryName}/${INSTALLATION_STEP_PROVISIONED}"
  local -r MarkerAgentProvisioned="${AgentHomeDirectoryName}/${INSTALLATION_STEP_PROVISIONED}"
  local -r MarkerInstalled="${HomeDirectoryName}/${INSTALLATION_STEP_INSTALLED}"
  local -r MarkerRootConfigured="${HomeDirectoryName}/${INSTALLATION_STEP_CONFIGURED}_ROOT"
  local -i bRepositoryCreated=$VALUE_FALSE
  local -i bResponseCreated=$VALUE_FALSE
  local -a FileNames
  local FileName=''
  local PatchNumber=''

  if [[ $RETCODE_SUCCESS -ne $Retcode ]] ; then
    echo "$Message"
  fi

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$MarkerProvisioned" '-o' '-f' "$MarkerInstalled"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} has already been provisioned or installed" "$HomeDirectoryName"
    else
      echoCommandMessage "the ${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} has not been provisioned" "$HomeDirectoryName"

      ##############################################################
      # Extraction of the Oracle Enterprise Manager package files. #
      ##############################################################

      echoSection "extraction of the ${DESCRIPTION_MANAGER_FILES}"

      executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$MarkerExtracted"
      if [[ 0 -eq $? ]] ; then
        echoCommandMessage "the ${DESCRIPTION_MANAGER_FILES} have already been extracted" "$MarkerExtracted"
      else
        echoCommandMessage "the ${DESCRIPTION_MANAGER_FILES} have not been extracted" "$MarkerExtracted"

        ### Validate that the staging directory can be written. ###

        if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
          executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-d' "$StagingDirectoryName" '-a' '-w' "$StagingDirectoryName"
          processCommandCode $? "the ${DESCRIPTION_STAGING_DIRECTORY} does not exist, is inaccessible, or is not writable" "$StagingDirectoryName"
          Retcode=$?
        fi

        ### (Re-)create the manager repository directory. ###

        createDirectory $? "$User" "$Group" '755' "$RepositoryDescription" "$Repository" '' '' $VALUE_TRUE
        Retcode=$?
        if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
          bRepositoryCreated=$VALUE_TRUE
        fi

        ### Read the names of the the manager package files. ###

        if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
          echoCommand "IFS=',' read -ra <<< ${PackagesFileNames}"
          IFS=',' read -ra FileNames <<< "$PackagesFileNames"
          processCommandCode $? "failed to read ${PackagesFileNamesDescription}" "$OPTION_MANAGER_PACKAGES_FILE_NAMES"
          Retcode=$?
        fi

        ### Validate that the manager package files are accessible. ###

        for FileName in ${FileNames[@]} ; do
          if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
            executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$FileName" '-a' '-r' "$FileName"
            processCommandCode $? "the ${DESCRIPTION_MANAGER_FILE} does not exist or is inaccessible" "$FileName"
            Retcode=$?
          fi
        done

        ### Extract the manager package files to the manager repository directory. ###

        for FileName in ${FileNames[@]} ; do
          extractFile $Retcode "$User" "$Group" "$DESCRIPTION_MANAGER_FILE" "$FileName" "$RepositoryDescription" "$Repository"
          Retcode=$?
        done

        ### Change the file ownership of the manager repository directory. ###

        setDirectoryAttributes $Retcode "$User" "$Group" "$RepositoryDescription" "$Repository"

        ### Create indicator that the Oracle Enterprise Manager package zip files have been unzipped. ###

        createMarker $? "$User" "$Group" "$MarkerExtracted"
        Retcode=$?
      fi

      ##############################
      # Extraction of the patches. #
      ##############################

      ### Extract the release upgrade patch. ###

      if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ -n "$UpgradePatchFileName" ]] ; then
        echoSection "extraction of the ${DESCRIPTION_MANAGER_UPGRADE_PATCH}" "$UpgradePatchFileName" "$PatchesDirectoryName"
        extractPatch \
          "$User" \
          "$Group" \
          "$DESCRIPTION_MANAGER_UPGRADE_PATCH" \
          "$DESCRIPTION_MANAGER_UPGRADE_PATCH_FILE" \
          "$UpgradePatchFileName" \
          "$UpgradePatchFileNameDescription" \
          "$DESCRIPTION_PATCHES_DIRECTORY" \
          "$PatchesDirectoryName"
        Retcode=$?
      fi

      ### Extract the patches. ###

      if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ -n "$PatchesFileNames" ]] ; then
        echoSection "extraction of the ${DESCRIPTION_MANAGER_PATCH_FILES}" "$PatchesFileNames" "$PatchesDirectoryName"
        FileNames=()
        if [[ 0 -eq $Retcode ]] ; then
          echoCommand "IFS=',' read -ra <<< ${PatchesFileNames}"
          IFS=',' read -ra FileNames <<< "$PatchesFileNames"
          processCommandCode $? "failed to read ${PatchesFileNamesDescription}" "$OPTION_MANAGER_PACKAGES_FILE_NAMES"
          Retcode=$?
        fi
        for FileName in ${FileNames[@]} ; do
          extractPatch \
            "$User" \
            "$Group" \
            "$DESCRIPTION_MANAGER_PATCH" \
            "$DESCRIPTION_MANAGER_PATCH_FILE" \
            "$FileName" \
            "$PatchesFileNamesDescription" \
            "$DESCRIPTION_PATCHES_DIRECTORY" \
            "$PatchesDirectoryName"
          Retcode=$?
          if [[ $RETCODE_SUCCESS -ne $Retcode ]] ; then
            break
          fi
        done
      fi

      ###############################################
      # Generation of the extraction response file. #
      ###############################################

      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        echoSection "generation of the extraction ${DESCRIPTION_MANAGER_RESPONSE_FILE}"
      fi

      ### Generate the response file. ###

      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$MarkerInstalled" '-a' '-f' "$MarkerInstalled"
        if [[ 0 -eq $? ]] ; then
          echoCommandMessage "the ${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} is already installed and configured" "$HomeDirectoryName"
        else
          echoCommandMessage "the ${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} has not been installed and configured" "$HomeDirectoryName"
          echoInfo "a ${DESCRIPTION_MANAGER_RESPONSE_FILE} will be generated" "$ResponseFileName"
          local FileContent=''
          read -d '' FileContent <<EOF
RESPONSEFILE_VERSION=2.2.1.0.0
UNIX_GROUP_NAME=${Group}
# Installation
CONFIGURATION_TYPE=LATER
b_upgrade=false
INSTALL_UPDATES_SELECTION=skip
EM_INSTALL_TYPE=NOSEED
EMPREREQ_AUTO_CORRECTION=true
CONFIGURE_ORACLE_SOFTWARE_LIBRARY=true
SOFTWARE_LIBRARY_LOCATION=${BaseDirectoryName}/software
INVENTORY_LOCATION=${InventoryDirectoryName}
ORACLE_MIDDLEWARE_HOME_LOCATION=${HomeDirectoryName}
AGENT_BASE_DIR=${AgentBaseDirectoryName}
EOF
          local -r FileContent
          createFile $Retcode "$User" "$Group" "$ResponseFilePermissions" "$DESCRIPTION_MANAGER_RESPONSE_FILE" "$ResponseFileName" 'FileContent' $VALUE_TRUE 'bResponseCreated'
          Retcode=$?
        fi
      fi

      #########################################################
      # Extraction of the Oracle Enterprise Manager software. #
      #########################################################

      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        echoSection "extraction of the ${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} software"
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
        echoCommand 'export' "ORACLE_HOME=${HomeDirectoryName}"
        export ORACLE_HOME="$HomeDirectoryName"
        processCommandCode $? 'failed to export the environment variable ORACLE_HOME' "$HomeDirectoryName"
        Retcode=$?
      fi

      ### Extract the Oracle Enterprise Manager. ###

      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'sudo' '-E' '-u' "$User" '-g' "$Group" "$Extractor" '-silent' '-responseFile' "$ResponseFileName" "-J-Djava.io.tmpdir=${StagingDirectoryName}"
        processCommandCode $? "an error occurred when running the ${ExtractorDescription}" "$Extractor"
        createMarker $? "$User" "$Group" "$MarkerProvisioned"
        createMarker $? "$User" "$Group" "$MarkerAgentProvisioned"
        Retcode=$?
      fi

      ### Delete the response file. ###

      if [[ $VALUE_TRUE -eq $bResponseCreated ]] ; then
        deleteFile "$DESCRIPTION_MANAGER_RESPONSE_FILE" "$ResponseFileName" "$User"
      fi
    fi
  fi

  ######################################
  # Perform the post-extraction steps. #
  ######################################

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoSection "Post-extraction steps"
  fi

  ### Run the Oracle Enterprise Manager root installer program using the root user. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$MarkerRootConfigured"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${RootInstallerDescription} has already been run" "$RootInstaller"
      Retcode=$?
    else
      echoCommandMessage "the ${RootInstallerDescription} has not already been run" "$RootInstaller"
      executeCommand 'sudo' '-E' '-u' "$User" '-g' "$Group" 'sudo' 'test' '-x' "$RootInstaller"
      processCommandCode $? "the ${RootInstallerDescription} does not exist or is inaccessible" "$RootInstaller"
      Retcode=$?
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'sudo' '-E' '-u' "$User" '-g' "$Group" 'sudo' '-E' "$RootInstaller"
        processCommandCode $? "an error occurred when running the ${RootInstallerDescription}" "$RootInstaller"
        createMarker $? "$User" "$Group" "$MarkerRootConfigured"
        Retcode=$?
      fi
    fi
  fi


  ### Correct missing Oracle instant client library. ###

  createFileLink $Retcode "$User" "$Group" 'Oracle Instant Client library' "$InstantClientLibrary" "${HomeDirectoryName}/lib/libclntshcore.so.12.1"
  createFileLink $?       "$User" "$Group" 'Oracle Instant Client library' "$InstantClientLibrary" "${HomeDirectoryName}/lib/libclntshcore.so"
  createFileLink $?       "$User" "$Group" 'Oracle Instant Client library' "$InstantClientLibrary" "${HomeDirectoryName}/instantclient/libclntshcore.so.12.1"
  Retcode=$?

  #########################################
  # Update the product patcher utilities. #
  #########################################

  ### Update the OPatch utility. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ -n "$OPatchFileName" ]] ; then
    local -r OPatchHomeDirectoryName="${HomeDirectoryName}/OPatch"
    echoSection "update the ${DESCRIPTION_MANAGER_OPATCH}" "$OPatchFileName" "$OPatchHomeDirectoryName"
    determinePatchNumber 'PatchNumber' "$OPatchFileName" "$OPatchFileNameDescription"
    Retcode=$?
    if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ -n "$PatchNumber" ]] ; then
      updatePatcher \
        "$User" \
        "$Group" \
        "$DESCRIPTION_MANAGER_OPATCH" \
        "$DESCRIPTION_MANAGER_OPATCH_FILE" \
        "$OPatchFileName" \
        "$DESCRIPTION_MANAGER_OPATCH_HOME" \
        "$OPatchHomeDirectoryName" \
        "${HomeDirectoryName}/${INSTALLATION_STEP_PATCHED}_${PatchNumber}"
      Retcode=$?
    fi
  fi

  ### Update the OMSPatcher utility. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ -n "$OMSPatcherFileName" ]] ; then
    local -r OMSPatcherHomeDirectoryName="${HomeDirectoryName}/OMSPatcher"
    echoSection "update the ${DESCRIPTION_MANAGER_OMSPATCHER}" "$OMSPatcherFileName" "$OMSPatcherHomeDirectoryName"
    determinePatchNumber 'PatchNumber' "$OMSPatcherFileName" "$OMSPatcherFileNameDescription"
    Retcode=$?
    if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ -n "$PatchNumber" ]] ; then
      updatePatcher \
        "$User" \
        "$Group" \
        "$DESCRIPTION_MANAGER_OMSPATCHER" \
        "$DESCRIPTION_MANAGER_OMSPATCHER_FILE" \
        "$OMSPatcherFileName" \
        "$DESCRIPTION_MANAGER_OMSPATCHER_HOME" \
        "$OMSPatcherHomeDirectoryName" \
        "${HomeDirectoryName}/${INSTALLATION_STEP_PATCHED}_${PatchNumber}"
      Retcode=$?
    fi
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
  local StagingDirectoryName
  local User
  local Group
  local DatabasePassword
  local BaseDirectoryName
  local HomeDirectoryName
  local InstanceDirectoryName
  local ManagerPassword
  local AgentBaseDirectoryName
  local WeblogicPassword
  echoTitle "de-installing the ${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]}"
  retrieveOption $? "$1" "$2" "$OPTION_STAGING_DIRECTORY_NAME"          'Message' 'StagingDirectoryName'
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_USER"               'Message' 'User'
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_GROUP"              'Message' 'Group'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_PASSWORD"               'Message' 'DatabasePassword'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_BASE_DIRECTORY_NAME"     'Message' 'BaseDirectoryName'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_HOME_DIRECTORY_NAME"     'Message' 'HomeDirectoryName'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_INSTANCE_DIRECTORY_NAME" 'Message' 'InstanceDirectoryName'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_PASSWORD"                'Message' 'ManagerPassword'
  retrieveOption $? "$1" "$2" "$OPTION_AGENT_BASE_DIRECTORY_NAME"       'Message' 'AgentBaseDirectoryName'
  retrieveOption $? "$1" "$2" "$OPTION_WEBLOGIC_PASSWORD"               'Message' 'WeblogicPassword'
  local -i Retcode=$?
  local -r Deinstaller1="${HomeDirectoryName}/sysman/install/EMDeinstall.pl"
  local -r Deinstaller2="${StagingDirectoryName}/EMDeinstall.pl"
  local -r DeinstallerDescription="${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} de-installer program"
  local -r MarkerProvisioned="${HomeDirectoryName}/${INSTALLATION_STEP_PROVISIONED}"
  local -r MarkerInstalled="${HomeDirectoryName}/${INSTALLATION_STEP_INSTALLED}"
  local -i bProceed=$VALUE_FALSE

  if [[ $RETCODE_SUCCESS -ne $Retcode ]] ; then
    echo "$Message"
    return $Retcode
  fi

  ### Validate that the Oracle Enterprise Manager is installed in the provided home directory. ###

  executeCommand 'sudo' 'test' '-d' "$HomeDirectoryName"
  if [[ 0 -eq $? ]] ; then
    echoCommandMessage "the ${DESCRIPTION_MANAGER_HOME_DIRECTORY} exists" "$HomeDirectoryName"
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$MarkerProvisioned"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} software is provisioned" "$HomeDirectoryName"
      executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$MarkerInstalled"
      if [[ 0 -eq $? ]] ; then
        echoCommandMessage "the ${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} software is installed" "$HomeDirectoryName"
        bProceed=$VALUE_TRUE
      else
        echoCommandMessage "the ${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} software has not been installed" "$HomeDirectoryName"
      fi
    else
      echoCommandMessage "the ${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} software has not been provisioned" "$HomeDirectoryName"
    fi
  else
    echoCommandMessage "the ${DESCRIPTION_MANAGER_HOME_DIRECTORY} does not exist" "$HomeDirectoryName"
  fi

  #####################################################################
  # Preparation for de-installation of the Oracle Enterprise Manager. #
  #####################################################################

  if [[ $VALUE_TRUE -eq $bProceed ]] ; then
    echoSection "Preparation for de-installation of the ${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]}"
  fi

  ### Validate that the Oracle Enterprise Manager de-installer program is present. ###

  if [[ $VALUE_TRUE -eq $bProceed ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-r' "$Deinstaller1"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${DeinstallerDescription} exists" "$Deinstaller1"
    else
      echoCommandMessage "the ${DeinstallerDescription} does not exist or is inaccessible" "$Deinstaller1"
      return $RETCODE_SUCCESS
    fi
  fi

  ### Copy the Oracle Enterprise Manager de-installer program to the staging location. ###

  if [[ $VALUE_TRUE -eq $bProceed ]] ; then
    executeCommand 'sudo' '-u' "${User}" '-g' "$Group" 'cp' "$Deinstaller1" "$Deinstaller2"
    processCommandCode $? "the ${DeinstallerDescription} '${Deinstaller1}' was not copied to '${Deinstaller2}'"
    Retcode=$?
    if [[ $RETCODE_SUCCESS -ne $Retcode ]] ; then
      return $Retcode
    fi
  fi

  #####################################################
  # De-installation of the Oracle Enterprise Manager. #
  #####################################################

  if [[ $VALUE_TRUE -eq $bProceed ]] ; then
    echoSection "De-installation of the ${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]}"
    echoCommand 'printf' "y\n${DatabasePassword}\n${ManagerPassword}\n${WeblogicPassword}\n" '|' 'sudo' 'su' '-' "$User" '-s' '/usr/bin/bash' '-c' "${HomeDirectoryName}/perl/bin/perl" "$Deinstaller2" '-mwHome' "$HomeDirectoryName" '-stageLoc' "$StagingDirectoryName"
    printf "y\n${DatabasePassword}\n${ManagerPassword}\n${WeblogicPassword}\n" | sudo 'su' '-' "${User}" '-s' '/usr/bin/bash' '-c' "${HomeDirectoryName}/perl/bin/perl ${Deinstaller2} -mwHome ${HomeDirectoryName} -stageLoc ${StagingDirectoryName}"
    processCommandCode $? "an error occurred when running the ${DeinstallerDescription}" "$Deinstaller2"
    Retcode=$?
  fi

  #############
  # Clean-up. #
  #############

  echoSection 'Clean-up'

  if [[ $VALUE_FALSE -eq $bProceed ]] ; then
    ### Delete the Oracle Enterprise Manager base directory. ###
    echoInfo "deleting the installation directories instead"
    deleteDirectory "$DESCRIPTION_AGENT_BASE_DIRECTORY" "$AgentBaseDirectoryName" "$User"
    deleteDirectory "$DESCRIPTION_MANAGER_INSTANCE_DIRECTORY" "$InstanceDirectoryName" "$User"
    deleteDirectory "$DESCRIPTION_MANAGER_BASE_DIRECTORY" "$BaseDirectoryName" "$User"
  else
    ### Delete the staged Oracle Enterprise Manager de-installer program. ###
    deleteFile "$DeinstallerDescription" "$Deinstaller2" "$User"
    local -r -i Retcode2=$?
    if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
      Retcode=$Retcode2
    fi
  fi

  ### Delete any remaining files. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    deleteFile 'Oracle Grid Control homes file' "/etc/oragchomelist"
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
## @fn prepareInstallation
##
## @brief Prepare the system for the installation of the Oracle products.
##
## @param[in] Sources The name of the variable that contains the sources of the
##                    program option values.
## @param[in] Values  The name of the vatiable that contains the program option
##                    values.
## @param[in] Target  The target of the installation.
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
  local -r Target="${3:-${PRODUCT_ALL}}"
  local Message=''
  local Capture=''
  local StagingDirectoryName
  local PatchesDirectoryName
  local InstallationInventoryDirectoryName
  local InstallationBaseDirectoryName
  local InstallationPermissions
  local User
  local UserDescription
  local Group
  local GroupDescription
  local HostName
  local DatabaseHomeDirectoryName
  local DatabaseName
  local DBAGroupName
  local ManagerVersion
  local ManagerHomeDirectoryName
  local ManagerInstanceDirectoryName
  local AgentBaseDirectoryName
  local AgentHomeDirectoryName
  local SudoersFileName
  local SudoersFilePermissions
  local SwapGoal
  local SwapGoalDescription
  local SwapFileName
  local SwapFilePermissions
  local SysctlFileName
  local SysctlFilePermissions
  local LimitsDatabaseFileName
  local LimitsManagerFileName
  local LimitsFilePermissions
  local ControlLerFileName
  local ControlLerFilePermissions
  local ServiceName
  local SystemdFileName
  local SystemdFilePermissions
  echoTitle 'preparing for installation of the Oracle products'
  retrieveOption $? "$1" "$2" "$OPTION_STAGING_DIRECTORY_NAME"                'Message' 'StagingDirectoryName'
  retrieveOption $? "$1" "$2" "$OPTION_PATCHES_DIRECTORY_NAME"                'Message' 'PatchesDirectoryName'
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_INVENTORY_DIRECTORY_NAME" 'Message' 'InstallationInventoryDirectoryName'
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_BASE_DIRECTORY_NAME"      'Message' 'InstallationBaseDirectoryName'
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_FILE_PERMISSIONS"         'Message' 'InstallationPermissions'
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_USER"                     'Message' 'User' 'UserDescription'
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_GROUP"                    'Message' 'Group' 'GroupDescription'
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_HOSTNAME"                 'Message' 'HostName'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_HOME_DIRECTORY_NAME"          'Message' 'DatabaseHomeDirectoryName'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_NAME"                         'Message' 'DatabaseName'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_ADMINISTRATOR_GROUP_NAME"     'Message' 'DBAGroupName'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_VERSION"                       'Message' 'ManagerVersion'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_HOME_DIRECTORY_NAME"           'Message' 'ManagerHomeDirectoryName'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_INSTANCE_DIRECTORY_NAME"       'Message' 'ManagerInstanceDirectoryName'
  retrieveOption $? "$1" "$2" "$OPTION_AGENT_BASE_DIRECTORY_NAME"             'Message' 'AgentBaseDirectoryName'
  retrieveOption $? "$1" "$2" "$OPTION_AGENT_HOME_DIRECTORY_NAME"             'Message' 'AgentHomeDirectoryName'
  retrieveOption $? "$1" "$2" "$OPTION_SUDOERS_FILE_NAME"                     'Message' 'SudoersFileName'
  retrieveOption $? "$1" "$2" "$OPTION_SUDOERS_FILE_PERMISSIONS"              'Message' 'SudoersFilePermissions'
  retrieveOption $? "$1" "$2" "$OPTION_SWAP_GOAL"                             'Message' 'SwapGoal' 'SwapGoalDescription'
  retrieveOption $? "$1" "$2" "$OPTION_SWAP_FILE_NAME"                        'Message' 'SwapFileName'
  retrieveOption $? "$1" "$2" "$OPTION_SWAP_FILE_PERMISSIONS"                 'Message' 'SwapFilePermissions'
  retrieveOption $? "$1" "$2" "$OPTION_SYSCTL_FILE_NAME"                      'Message' 'SysctlFileName'
  retrieveOption $? "$1" "$2" "$OPTION_SYSCTL_FILE_PERMISSIONS"               'Message' 'SysctlFilePermissions'
  retrieveOption $? "$1" "$2" "$OPTION_LIMITS_DATABASE_FILE_NAME"             'Message' 'LimitsDatabaseFileName'
  retrieveOption $? "$1" "$2" "$OPTION_LIMITS_MANAGER_FILE_NAME"              'Message' 'LimitsManagerFileName'
  retrieveOption $? "$1" "$2" "$OPTION_LIMITS_FILE_PERMISSIONS"               'Message' 'LimitsFilePermissions'
  retrieveOption $? "$1" "$2" "$OPTION_CONTROLLER_FILE_NAME"                  'Message' 'ControllerFileName'
  retrieveOption $? "$1" "$2" "$OPTION_CONTROLLER_FILE_PERMISSIONS"           'Message' 'ControllerFilePermissions'
  retrieveOption $? "$1" "$2" "$OPTION_SYSTEMD_SERVICE_NAME"                  'Message' 'ServiceName'
  retrieveOption $? "$1" "$2" "$OPTION_SYSTEMD_FILE_NAME"                     'Message' 'SystemdFileName'
  retrieveOption $? "$1" "$2" "$OPTION_SYSTEMD_FILE_PERMISSIONS"              'Message' 'SystemdFilePermissions'
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
    executeCommandOutput 'Capture' 'sudo' 'getent' 'group' "$Group"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${GroupDescription} already exists" "$Group" "$Capture"
    else
      echoCommandMessage "the ${GroupDescription} does not exist" "$Group" "$Capture"
      executeCommand 'sudo' '/usr/sbin/groupadd' '-g' '54321' "$Group"
      processCommandCode $? "failed to create the ${GroupDescription}" "$Group"
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
      echoCommandMessage "the ${UserDescription} already exists" "$User"
      echoCommand 'echo' "$Output1" '|' 'awk' "-F ' ' '{ print \$2 }'" '|' 'awk' "-F '(' '{ print \$2 }'" '|' 'tr' "-d' ')'"
      Output2=$(echo "$Output1" | awk -F ' ' '{ print $2 }' | awk -F '(' '{ print $2 }' | tr -d ')')
      processCommandCode $? "failed to validate group membership of the ${UserDescription}" "$User"
      Retcode=$?
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        if [[ "$Group" == "$Output2" ]] ; then
          echoInfo "the primary group of the ${UserDescription} '${User}' is the ${GroupDescription}" "$Group"
        else
          echoError $RETCODE_OPERATION_ERROR "the primary group of the ${UserDescription} '${User}' is not the ${GroupDescription}" "$Group" "$Output2"
        fi
        Retcode=$?
      fi
    else
      echoCommandMessage "the ${UserDescription} does not exist" "$User"
      executeCommand 'sudo' '/usr/sbin/useradd' '-u' '54321' '-g' "$Group" '-s' '/bin/bash' '-m' "$User"
      processCommandCode $? "failed to create the ${UserDescription}" "${User}:${Group}"
      Retcode=$?
    fi
  fi

  if [[ "$PRODUCT_ALL" == "$Target" ]] || [[ "$PRODUCT_DATABASE" == "$Target" ]] ; then
    ### Create the database administrator group. ###

    if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
      executeCommandOutput 'Capture' 'sudo' 'getent' 'group' "$DBAGroupName"
      if [[ 0 -eq $? ]] ; then
        echoCommandMessage "the ${DESCRIPTION_DATABASE_ADMINISTRATOR_GROUP} already exists" "$DBAGroupName" "$Capture"
      else
        echoCommandMessage "the ${DESCRIPTION_DATABASE_ADMINISTRATOR_GROUP} does not exist" "$DBAGroupName" "$Capture"
        executeCommand 'sudo' '/usr/sbin/groupadd' '-g' '54322' "$DBAGroupName"
        processCommandCode $? "failed to create the ${DESCRIPTION_DATABASE_ADMINISTRATOR_GROUP}" "$DBAGroupName"
      fi
      Retcode=$?
    fi

    ### Confirm that the installation user is member of the database administrator group. ###

    if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
      local Output3=''
      local Output4=''
      echoCommand 'sudo' 'getent' 'group' "$DBAGroupName"
      Output3=$(sudo getent 'group' "$DBAGroupName")
      processCommandCode $? "the ${DESCRIPTION_DATABASE_ADMINISTRATOR_GROUP} does not exist" "$DBAGroupName"
      Retcode=$?
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        echoCommand 'echo' "$Output3" '|' 'awk' '-F' ':' '{ print $4}'
        Output4=$(echo "$Output3" | awk -F ':' '{ print $4}')
        if [[ 0 -eq $? ]] && [[ "$User" == "$Output4" ]] ; then
          echoCommandMessage "the ${UserDescription} '${User}' is already a member of the ${DESCRIPTION_DATABASE_ADMINISTRATOR_GROUP}" "$DBAGroupName"
        else
          echoCommandMessage "the ${UserDescription} '${User}' is not a member of the ${DESCRIPTION_DATABASE_ADMINISTRATOR_GROUP}" "$DBAGroupName" "$Output4"
          executeCommand 'sudo' 'usermod' '-a' '-G' "$DBAGroupName" "$User"
          processCommandCode $? "failed to add the ${UserDescription} '${User}' to the ${DESCRIPTION_DATABASE_ADMINISTRATOR_GROUP}" "$DBAGroupName"
        fi
        Retcode=$?
      fi
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
    processCommandCode $ExitCode "failed to determine the home directory of the ${UserDescription}" "$User"
    Retcode=$?
    if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
      echoInfo "the home directory of the ${UserDescription} '${User}'" "$Output5"
      executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-d' "$Output5"
      processCommandCode $? "failed to access the home directory of the ${UserDescription} (${User})" "$Output5"
      Retcode=$?
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        local -r UserHomeDirectoryName="$Output5"
      fi
    fi
  fi

  ### Update the .bashrc of the new installation user. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    appendLine $Retcode "${UserHomeDirectoryName}/.bashrc" 'export PATH="/usr/local/bin:${PATH}"' '"'
    appendLine $?       "${UserHomeDirectoryName}/.bashrc" "export ORACLE_HOSTNAME='${HostName}'" "'"
    Retcode=$?
    if [[ "$PRODUCT_ALL" == "$Target" ]] || [[ "$PRODUCT_DATABASE" == "$Target" ]] ; then
      appendLine $Retcode "${UserHomeDirectoryName}/.bashrc" "export ORACLE_SID='${DatabaseName}'" "'"
      appendLine $?       "${UserHomeDirectoryName}/.bashrc" "export DATABASE_HOME='${DatabaseHomeDirectoryName}'" "'"
      Retcode=$?
    fi
    if [[ "$PRODUCT_ALL" == "$Target" ]] || [[ "$PRODUCT_MANAGER" == "$Target" ]] ; then
      appendLine $Retcode "${UserHomeDirectoryName}/.bashrc" "export OMS_HOME='${ManagerHomeDirectoryName}'" "'"
      Retcode=$?
    fi
    if [[ "$PRODUCT_ALL" == "$Target" ]] || [[ "$PRODUCT_MANAGER" == "$Target" ]] || [[ "$PRODUCT_AGENT" == "$Target" ]] ; then
      appendLine $Retcode "${UserHomeDirectoryName}/.bashrc" "export AGENT_HOME='${AgentHomeDirectoryName}'" "'"
      Retcode=$?
    fi
#    if [[ "$PRODUCT_ALL" == "$Target" ]] || [[ "$PRODUCT_DATABASE" == "$Target" ]] ; then
#      appendLine $Retcode "${UserHomeDirectoryName}/.bashrc" 'export ORACLE_HOME="${DATABASE_HOME}"' '"'
#      Retcode=$?
#    elif [[ "$PRODUCT_DATABASE" == "$Target" ]] ; then
#      appendLine $Retcode "${UserHomeDirectoryName}/.bashrc" 'export ORACLE_HOME="${MANAGER_HOME}"' '"'
#      Retcode=$?
#    fi
  fi

  ### Add the installation user to the operating systems's list of sudoers. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    local SudoersContent=''
    read -d '' SudoersContent <<EOF
# Created by ${PROGRAM} on $(date)
# Grant sudo privileges to the Oracle installation user
${User} ALL=(ALL) NOPASSWD:ALL
EOF
    local -r SudoersContent
    createFile $Retcode 'root' 'root' "$SudoersFilePermissions" "$DESCRIPTION_SUDOERS_FILE" "$SudoersFileName" 'SudoersContent'
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
    local -r PreRequisiteLibrary='pre-requisite system library'
    local -r Library_libnsl='libnsl'
    executeCommand 'test' '-f' '/usr/lib64/libnsl.so.1'
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${PreRequisiteLibrary} is already installed" "$Library_libnsl"
    else
      echoCommandMessage "a ${PreRequisiteLibrary} is not installed" "$Library_libnsl"
      executeCommand 'sudo' 'yum' '-y' 'install' "$Library_libnsl"
      processCommandCode $? "failed to install the ${PreRequisiteLibrary}" "$Library_libnsl"
      Retcode=$?
    fi
  fi

  #D######################################################
  # Adjustment of the system swap to have at least 16GB. #
  ########################################################

  if [[ "$PRODUCT_ALL" == "$Target" ]] || [[ "$PRODUCT_DATABASE" == "$Target" ]] ; then
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
        echoInfo "${SwapGoalDescription}" "${SwapGoal}GB"
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
        fi
        if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
          executeCommand 'sudo' 'chmod' "$SwapFilePermissions" "$SwapFileName"
          processCommandCode $? "failed to set the file system permissions of the ${DESCRIPTION_SWAP_FILE}" "$SwapFileName" "$SwapFilePermissions"
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
  fi

  #################################################################
  # Configuration of the Sysctl settings for the Oracle Database. #
  #################################################################

  if [[ "$PRODUCT_ALL" == "$Target" ]] || [[ "$PRODUCT_DATABASE" == "$Target" ]] ; then
    if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
      echoSection "Configuration of the ${DESCRIPTION_SYSCTL}"
    fi

    ### Create and activate the Systctl settings for the Oracle Database. ###

    if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
      local SysctlContent=''
      local -i bSysctlCreated=$VALUE_FALSE
      read -d '' SysctlContent <<EOF
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
EOF
      local -r SysctlContent
      createFile $Retcode 'root' 'root' "$SysctlFilePermissions" "$DESCRIPTION_SYSCTL_FILE" "$SysctlFileName" 'SysctlContent' $VALUE_FALSE 'bSysctlCreated'
      Retcode=$?
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ $VALUE_TRUE -eq $bSysctlCreated ]] ; then
        executeCommand 'sudo' '/sbin/sysctl' '-p' "$SysctlFileName"
        processCommandCode $? "failed to activate ${DESCRIPTION_SYSCT_FILE}" "$SysctlFileName"
        Retcode=$?
      fi
    fi
  fi

  ##########################################################################################
  # Configuration of the limits settings for the installation user of the Oracle products. #
  ##########################################################################################

  if [[ "$PRODUCT_ALL" == "$Target" ]] || [[ "$PRODUCT_DATABASE" == "$Target" ]] ; then
    if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
      echoSection "Configuration of the ${DESCRIPTION_LIMITS_DATABASE}"
    fi

    ### Create the limits settings for the installation user of the Oracle Database. ###

    if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
      local LimitsDatabaseContent=''
      read -d '' LimitsDatabaseContent <<EOF
# Created by ${PROGRAM} on $(date)
${User} soft nofile  1024
${User} hard nofile  65536
${User} soft nproc   16384
${User} hard nproc   16384
${User} soft stack   10240
${User} hard stack   32768
${User} hard memlock 134217728
${User} soft memlock 134217728
EOF
      local -r LimitsDatabaseContent
      createFile $Retcode 'root' 'root' "$LimitsFilePermissions" "$DESCRIPTION_LIMITS_DATABASE_FILE" "$LimitsDatabaseFileName" 'LimitsDatabaseContent'
      Retcode=$?
    fi
  fi

  if [[ "$PRODUCT_ALL" == "$Target" ]] || [[ "$PRODUCT_MANAGER" == "$Target" ]] ; then
    if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
      echoSection "Configuration of the ${DESCRIPTION_LIMITS_MANAGER}"
    fi

    ### Create the limits settings for the installation user of the Oracle Database. ###

    if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
      local LimitsManagerContent=''
      read -d '' LimitsManagerContent <<EOF
# Created by ${PROGRAM} on $(date)
${User} soft nofile 30000
${User} hard nofile 65536
${User} soft nproc  30000
${User} hard nproc  30000
EOF
      local -r LimitsManagerContent
      createFile $Retcode 'root' 'root' "$LimitsFilePermissions" "$DESCRIPTION_LIMITS_MANAGER_FILE" "$LimitsManagerFileName" 'LimitsManagerContent'
      Retcode=$?
    fi
  fi

  #####################################################################
  # Creation of the installation directories for the Oracle products. #
  #####################################################################

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoSection 'Creation of the installation directories for the Oracle products'
  fi

  ### Create the installation staging directory. ###

  createDirectory $Retcode "$User" "$Group" "$InstallationPermissions" "$DESCRIPTION_STAGING_DIRECTORY" "$StagingDirectoryName"

  ### Create the staging directory for product patches. ###

  createDirectory $Retcode "$User" "$Group" "$InstallationPermissions" "$DESCRIPTION_PATCHES_DIRECTORY" "$PatchesDirectoryName" "$DESCRIPTION_STAGING_DIRECTORY" "$StagingDirectoryName"

  ### Create the installation base directory. ###

  createDirectory $Retcode "$User" "$Group" "$InstallationPermissions" "$DESCRIPTION_INSTALLATION_BASE_DIRECTORY" "$InstallationBaseDirectoryName"
  Retcode=$?

  ### Create the installation inventory directory and the global pointer file. ###

  createDirectory $Retcode "$User" "$Group" "$InstallationPermissions" "$DESCRIPTION_INSTALLATION_INVENTORY_DIRECTORY" "$InstallationInventoryDirectoryName" "$DESCRIPTION_INSTALLATION_BASE_DIRECTORY" "$InstallationBaseDirectoryName"
  Retcode=$?
  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    local InventoryContent=''
    read -d '' InventoryContent <<EOF
# Created by ${PROGRAM} on $(date)
inventory_loc=${InstallationInventoryDirectoryName}
inst_group=${Group}
EOF
    local -r InventoryContent
    createFile $Retcode "$User" "$Group" "664" "Oracle Central Inventory pointer file" "$ORAINST_FILE_NAME" 'InventoryContent'
    Retcode=$?
  fi

  ### Create the Oracle Database home directory. ###

  if [[ "$PRODUCT_ALL" == "$Target" ]] || [[ "$PRODUCT_DATABASE" == "$Target" ]] ; then
    createDirectory $Retcode "$User" "$Group" "$InstallationPermissions" "$DESCRIPTION_DATABASE_HOME_DIRECTORY" "$DatabaseHomeDirectoryName" "$DESCRIPTION_INSTALLATION_BASE_DIRECTORY" "$InstallationBaseDirectoryName"
    Retcode=$?
  fi

  ### Create the Oracle Enterprise Manager home directory. ###

  if [[ "$PRODUCT_ALL" == "$Target" ]] || [[ "$PRODUCT_MANAGER" == "$Target" ]] ; then
    createDirectory $Retcode "$User" "$Group" "$InstallationPermissions" "$DESCRIPTION_MANAGER_HOME_DIRECTORY" "$ManagerHomeDirectoryName" "$DESCRIPTION_INSTALLATION_BASE_DIRECTORY" "$InstallationBaseDirectoryName"
    Retcode=$?
  fi

  ### Create the Oracle Enterprise Manager instance home directory. ###

  if [[ "$PRODUCT_ALL" == "$Target" ]] || [[ "$PRODUCT_MANAGER" == "$Target" ]] ; then
    createDirectory $Retcode "$User" "$Group" "$InstallationPermissions" "$DESCRIPTION_MANAGER_INSTANCE_DIRECTORY" "$ManagerInstanceDirectoryName" "$DESCRIPTION_INSTALLATION_BASE_DIRECTORY" "$InstallationBaseDirectoryName"
    Retcode=$?
  fi

  ### Create the Oracle Enterprise Manager agent base directory. ###

  if [[ "$PRODUCT_ALL" == "$Target" ]] || [[ "$PRODUCT_MANAGER" == "$Target" ]] || [[ "$PRODUCT_AGENT" == "$Target" ]] ; then
    createDirectory $Retcode "$User" "$Group" "$InstallationPermissions" "$DESCRIPTION_AGENT_BASE_DIRECTORY" "$AgentBaseDirectoryName" "$DESCRIPTION_INSTALLATION_BASE_DIRECTORY" "$InstallationBaseDirectoryName"
    Retcode=$?
  fi

  #######################################################
  # Create the Systemd service for the Oracle Database. #
  #######################################################

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoSection "Creation of the ${DESCRIPTION_SYSTEMD_SERVICE}"
  fi

  ### Create the Oracle Database service control program. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    local -r ControllerFile="${UserHomeDirectoryName}/${ControllerFileName}"
    local ControllerContent=''
    read -d '' ControllerContent <<EOF
#!/usr/bin/bash

# Created by ${PROGRAM} on $(date)

declare -r ORIGINAL_PATH=\"\\\$PATH\"

export TMPDIR=\"/tmp\"
export TMP=\"/tmp\"

controlAgent() {
  local -r RESPONSE_FILE=\"${AgentBaseDirectoryName}/agentInstall.rsp\"
  local Log=\"\"
  local -i Retcode=0
  if [[ -r \"\\\$RESPONSE_FILE\" ]] ; then
    export ORACLE_HOME=\\\$(grep 'ORACLE_HOME' \"\\\$RESPONSE_FILE\" | awk -F \"=\" \"{print \\\\\$2}"\)
    local -r Command=\"\\\${ORACLE_HOME}/bin/emctl\"
    if [[ -n \"\\\$ORACLE_HOME\" ]] && [[ -f "${AgentHomeDirectoryName}/${INSTALLATION_STEP_INSTALLED}" ]] && [[ -x \"\\\$Command\" ]] ; then
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
  export ORACLE_HOME=\"${DatabaseHomeDirectoryName}\"
  local -r Command=\"\\\${ORACLE_HOME}/bin/\\\${1}\"
  local Log=\"\"
  local -i Retcode=0
  if [[ -n \"\\\$ORACLE_HOME\" ]] && [[ -f "\\\${ORACLE_HOME}/${INSTALLATION_STEP_CONFIGURED}" ]] && [[ -x \"\\\$Command\" ]] ; then
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
  export ORACLE_HOME=\"${ManagerHomeDirectoryName}\"
  local -r Command=\"\\\${ORACLE_HOME}/bin/emctl\"
  local Log=\"\"
  local -i Retcode=0
  if [[ -n \"\\\$ORACLE_HOME\" ]] && [[ -f "\\\${ORACLE_HOME}/${INSTALLATION_STEP_INSTALLED}" ]] && [[ -x \"\\\$Command\" ]] ; then
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

declare Log=\"\"
declare -i Retcode=0

if [[ 1 -ne \\\$# ]] ; then
  Log=\"Incorrect number of parameters (\\\$#).  Expected the parameters start or stop only.\"
  Retcode=1
elif [[ \"start\" = \"\\\$1\" ]] ; then
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
elif [[ \"stop\" = \"\\\$1\" ]] ; then
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
EOF
    local -r ControllerContent
    createFile $Retcode "$User" "$Group" "$ControllerFilePermissions" "$DESCRIPTION_CONTROLLER_FILE" "$ControllerFile" 'ControllerContent' $VALUE_TRUE
    Retcode=$?
  fi

  ### Create the Systemd service file for Oracle Database. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    local SystemdContent=''
    local bSystemdCreated=$VALUE_FALSE
    read -d '' SystemdContent <<EOF
# Created by ${PROGRAM} on $(date)

[Unit]
Description=${DESCRIPTION_SYSTEMD_SERVICE}
After=syslog.target network.target

[Service]
Type=oneshot
LimitMEMLOCK=infinity
LimitNOFILE=65535
RemainAfterExit=true
User=${User}
Group=${Group}
Restart=no
ExecStart=/bin/bash ${ControllerFile} start
ExecStop=/bin/bash ${ControllerFile} stop

[Install]
WantedBy=multi-user.target
EOF
    local -r SystemdContent
    createFile $Retcode 'root' 'root' "$SystemdFilePermissions" "$DESCRIPTION_SYSTEMD_SERVICE_FILE" "$SystemdFileName" 'SystemdContent' $VALUE_TRUE 'bSystemdCreated'
    Retcode=$?
    if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ $VALLUE_TRUE -eq $bSystemdCreated ]] ; then
      executeCommand 'sudo' 'systemctl' 'enable' "$ServiceName"
      processCommandCode $? "failed to enable the ${DESCRIPTION_SYSTEMD_SERVICE}" "$ServiceName"
      Retcode=$?
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
       [[ "$COMMAND_PROVISION" == "$1" ]] || \
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
    if [[ "$COMMAND_PREPARE" == "$COMMAND" ]] || [[ "$COMMAND_PROVISION" == "$COMMAND" ]] || [[ "$COMMAND_INSTALL" == "$COMMAND" ]] || [[ "$COMMAND_UNINSTALL" == "$COMMAND" ]] ; then
      if [[ "$PRODUCT_DATABASE" == "$1" ]] || [[ "$PRODUCT_MANAGER" == "$1" ]] || [[ "$PRODUCT_AGENT" == "$1" ]] || [[ "$PRODUCT_ALL" == "$1" ]] ; then
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
    declare -r COMMAND_TARGET="$PRODUCT_ALL"
  fi
fi

# Process the options file, if one was provided.

processOptionsFile $Retcode 'Message' 'OptionSources' 'OptionValues'

# Process the determined options.

setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_PATCHES_DIRECTORY_NAME"                "${OptionValues[${OPTION_STAGING_DIRECTORY_NAME}]}/patches"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_INSTALLATION_ROOT_DIRECTORY_NAME"      "${OPTION_DEFAULT_VALUES[${OPTION_INSTALLATION_ROOT_DIRECTORY_NAME}]}"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_INSTALLATION_USER"                     "${OPTION_DEFAULT_VALUES[${OPTION_INSTALLATION_USER}]}"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_INSTALLATION_HOSTNAME"                 "${OPTION_DEFAULT_VALUES[${OPTION_INSTALLATION_HOSTNAME}]}"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_INSTALLATION_BASE_DIRECTORY_NAME"      "${OptionValues[${OPTION_INSTALLATION_ROOT_DIRECTORY_NAME}]}/${OptionValues[${OPTION_INSTALLATION_USER}]}"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_INSTALLATION_INVENTORY_DIRECTORY_NAME" "${OptionValues[${OPTION_INSTALLATION_ROOT_DIRECTORY_NAME}]}/oraInventory"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_DATABASE_VERSION"                      "${OPTION_DEFAULT_VALUES[${OPTION_DATABASE_VERSION}]}"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_DATABASE_NAME"                         "${OPTION_DEFAULT_VALUES[${OPTION_DATABASE_NAME}]}"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_DATABASE_HOSTNAME"                     "${OptionValues[${OPTION_INSTALLATION_HOSTNAME}]}"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_DATABASE_BASE_DIRECTORY_NAME"          "${OptionValues[${OPTION_INSTALLATION_BASE_DIRECTORY_NAME}]}/${PRODUCT_DATABASE}"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_DATABASE_HOME_DIRECTORY_NAME"          "${OptionValues[${OPTION_DATABASE_BASE_DIRECTORY_NAME}]}/product/${OptionValues[${OPTION_DATABASE_VERSION}]}"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_DATABASE_DATA_DIRECTORY_NAME"          "${OptionValues[${OPTION_DATABASE_BASE_DIRECTORY_NAME}]}/oradata/${OptionValues[${OPTION_DATABASE_NAME}]}"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_DATABASE_RECOVERY_DIRECTORY_NAME"      "${OptionValues[${OPTION_DATABASE_BASE_DIRECTORY_NAME}]}/recovery/${OptionValues[${OPTION_DATABASE_NAME}]}"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_MANAGER_VERSION"                       "${OPTION_DEFAULT_VALUES[${OPTION_MANAGER_VERSION}]}"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_MANAGER_BASE_DIRECTORY_NAME"           "${OptionValues[${OPTION_INSTALLATION_BASE_DIRECTORY_NAME}]}/${PRODUCT_MANAGER}"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_MANAGER_HOME_DIRECTORY_NAME"           "${OptionValues[${OPTION_MANAGER_BASE_DIRECTORY_NAME}]}/product/${OptionValues[${OPTION_MANAGER_VERSION}]}"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_MANAGER_INSTANCE_DIRECTORY_NAME"       "${OptionValues[${OPTION_MANAGER_BASE_DIRECTORY_NAME}]}/gc_inst"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_MANAGER_KEYSTORE_FILE_NAME"            "${OptionValues[${OPTION_MANAGER_BASE_DIRECTORY_NAME}]}/oradata/ewallet-keystore.p12"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_MANAGER_TRUSTSTORE_FILE_NAME"          "${OptionValues[${OPTION_MANAGER_BASE_DIRECTORY_NAME}]}/oradata/ewallet-truststore.p12"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_AGENT_BASE_DIRECTORY_NAME"             "${OptionValues[${OPTION_INSTALLATION_BASE_DIRECTORY_NAME}]}/${PRODUCT_AGENT}"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_AGENT_HOME_DIRECTORY_NAME"             "${OptionValues[${OPTION_AGENT_BASE_DIRECTORY_NAME}]}/agent_${OptionValues[${OPTION_MANAGER_VERSION}]}"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_AGENT_INSTANCE_DIRECTORY_NAME"         "${OptionValues[${OPTION_AGENT_BASE_DIRECTORY_NAME}]}/agent_inst"
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
  echoInfo "COMMAND" "$COMMAND"
  echoInfo "TARGET" "$COMMAND_TARGET"
  case "$COMMAND" in
    "$COMMAND_HELP")
      echoHelp $VALUE_TRUE
      Retcode=$?
      ;;
    "$COMMAND_OPTIONS")
      displayOptions 'OptionSources' 'OptionValues'
      Retcode=$?
      ;;
    "$COMMAND_PREPARE"|"$COMMAND_PROVISION"|"$COMMAND_INSTALL")
      displayOptions 'OptionSources' 'OptionValues'
      Retcode=$?
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        prepareInstallation 'OptionSources' 'OptionValues' "$COMMAND_TARGET"
        Retcode=$?
      fi
      if [[ "$COMMAND_PROVISION" == "$COMMAND" ]] || [[ "$COMMAND_INSTALL" == "$COMMAND" ]]; then
        if [[ "$PRODUCT_ALL" == "$COMMAND_TARGET" ]] || [[ "$PRODUCT_DATABASE" == "$COMMAND_TARGET" ]] ; then
          if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
            provisionDatabase 'OptionSources' 'OptionValues'
            Retcode=$?
          fi
        fi
        if [[ "$PRODUCT_ALL" == "$COMMAND_TARGET" ]] || [[ "$PRODUCT_MANAGER" == "$COMMAND_TARGET" ]] ; then
          if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
            provisionManager 'OptionSources' 'OptionValues'
            Retcode=$?
          fi
        fi
      fi
      if [[ "$COMMAND_INSTALL" == "$COMMAND" ]]; then
        if [[ "$PRODUCT_ALL" == "$COMMAND_TARGET" ]] || [[ "$PRODUCT_DATABASE" == "$COMMAND_TARGET" ]] ; then
          if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
            installDatabase 'OptionSources' 'OptionValues'
            Retcode=$?
          fi
        fi
        if [[ "$PRODUCT_ALL" == "$COMMAND_TARGET" ]] || [[ "$PRODUCT_MANAGER" == "$COMMAND_TARGET" ]] ; then
          if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
            installManager 'OptionSources' 'OptionValues'
            Retcode=$?
          fi
        fi
      fi
      ;;
    "$COMMAND_UNINSTALL")
      displayOptions 'OptionSources' 'OptionValues'
      Retcode=$?
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        if [[ "$PRODUCT_ALL" == "$COMMAND_TARGET" ]] || [[ "$PRODUCT_MANAGER" == "$COMMAND_TARGET" ]] ; then
          uninstallManager 'OptionSources' 'OptionValues'
          Retcode=$?
        fi
      fi
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        if [[ "$PRODUCT_ALL" == "$COMMAND_TARGET" ]] || [[ "$PRODUCT_DATABASE" == "$COMMAND_TARGET" ]] ; then
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
  echoError $Retcode "$Message"
fi

case "$COMMAND" in
  "$COMMAND_PREPARE")
    if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
      echoInfo "System preparation successful: ${Retcode}"
    else
      echoInfo "System preparation failed: ${Retcode}"
    fi
    ;;
  "$COMMAND_PROVISION")
    if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
      echoInfo "Provisioning successful: ${Retcode}"
    else
      echoInfo "Provisioning failed: ${Retcode}"
    fi
    ;;
  "$COMMAND_INSTALL")
    if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
      echoInfo "Installation successful: ${Retcode}"
      if [[ -z "$COMMAND_TARGET" ]] || [[ "$PRODUCT_DATABASE" == "$COMMAND_TARGET" ]] ; then
        echoInfo "Environment variables for the ${PRODUCT_DESCRIPTIONS[${PRODUCT_DATABASE}]}"
        echoInfo "ORACLE_BASE=${OptionValues[${OPTION_DATABASE_BASE_DIRECTORY_NAME}]}"
        echoInfo "ORACLE_HOME=${OptionValues[${OPTION_DATABASE_HOME_DIRECTORY_NAME}]}"
      fi
      if [[ -z "$COMMAND_TARGET" ]] || [[ "$PRODUCT_MANAGER" == "$COMMAND_TARGET" ]] ; then
        echoInfo "Environment variables for the ${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]}"
        echoInfo "ORACLE_BASE=${OptionValues[${OPTION_MANAGER_BASE_DIRECTORY_NAME}]}"
        echoInfo "ORACLE_HOME=${OptionValues[${OPTION_MANAGER_HOME_DIRECTORY_NAME}]}"
      fi
    else
      echoInfo "Installation failed: ${Retcode}"
    fi
    ;;
  "$COMMAND_UNINSTALL")
    if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
      echoInfo "Uninstallation successful: ${Retcode}"
    else
      echoInfo "Uninstallation failed: ${Retcode}"
    fi
    ;;
  *)
    ;;
esac

echoInfo "Log file: ${LogFile}"

exit $Retcode
