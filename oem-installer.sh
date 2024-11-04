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
declare -r DESCRIPTION_PRODUCT_DATABASE='Oracle Database'
declare -r DESCRIPTION_PRODUCT_MANAGER='Oracle Enterprise Manager'
declare -r DESCRIPTION_PRODUCT_AGENT="${DESCRIPTION_PRODUCT_MANAGER} Agent"
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
  ["$PRODUCT_AGENT"]="${PRODUCT_DESCRIPTIONS[${PRODUCT_MANAGER}]} agent"
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
declare -r OPTION_FILE='options-file'
declare -r OPTION_REPOSITORY_ROOT='repository'
declare -r OPTION_REPOSITORY_ARCHIVE='archive'
declare -r OPTION_INSTALLATION_STAGE='stage'
declare -r OPTION_INSTALLATION_ROOT='installation-root'
declare -r OPTION_INSTALLATION_INVENTORY='installation-inventory'
declare -r OPTION_INSTALLATION_BASE='installation-base'
declare -r OPTION_INSTALLATION_FILE_PERMISSIONS='installation-file-permissions'
declare -r OPTION_INSTALLATION_USER='user'
declare -r OPTION_INSTALLATION_GROUP='group'
declare -r OPTION_INSTALLATION_HOSTNAME='hostname'
declare -r OPTION_DATABASE_VERSION='database-version'
declare -r OPTION_DATABASE_REPOSITORY='database-repository'
declare -r OPTION_DATABASE_PACKAGE_FILE_NAME='database-package'
declare -r OPTION_DATABASE_OPATCH_FILE_NAME='database-opatch'
declare -r OPTION_DATABASE_PATCH_FILE_NAME='database-patch'
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
declare -r OPTION_MANAGER_REPOSITORY='manager-repository'
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
  "$OPTION_FILE"
  "$OPTION_REPOSITORY_ROOT"
  "$OPTION_REPOSITORY_ARCHIVE"
  "$OPTION_INSTALLATION_STAGE"
  "$OPTION_INSTALLATION_ROOT"
  "$OPTION_INSTALLATION_INVENTORY"
  "$OPTION_INSTALLATION_BASE"
  "$OPTION_INSTALLATION_FILE_PERMISSIONS"
  "$OPTION_INSTALLATION_USER"
  "$OPTION_INSTALLATION_GROUP"
  "$OPTION_INSTALLATION_HOSTNAME"
  "$OPTION_DATABASE_VERSION"
  "$OPTION_DATABASE_REPOSITORY"
  "$OPTION_DATABASE_PACKAGE_FILE_NAME"
  "$OPTION_DATABASE_OPATCH_FILE_NAME"
  "$OPTION_DATABASE_PATCH_FILE_NAME"
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
  "$OPTION_MANAGER_REPOSITORY"
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
  ["$OPTION_FILE"]=$OPTION_SOURCE_COMMAND
  ["$OPTION_REPOSITORY_ROOT"]=$OPTION_SOURCE_ALL
  ["$OPTION_REPOSITORY_ARCHIVE"]=$OPTION_SOURCE_ALL
  ["$OPTION_INSTALLATION_STAGE"]=$OPTION_SOURCE_ALL
  ["$OPTION_INSTALLATION_ROOT"]=$OPTION_SOURCE_ALL
  ["$OPTION_INSTALLATION_INVENTORY"]=$OPTION_SOURCE_PROGRAM
  ["$OPTION_INSTALLATION_BASE"]=$OPTION_SOURCE_PROGRAM
  ["$OPTION_INSTALLATION_FILE_PERMISSIONS"]=$OPTION_SOURCE_PROGRAM
  ["$OPTION_INSTALLATION_USER"]=$OPTION_SOURCE_ALL
  ["$OPTION_INSTALLATION_GROUP"]=$OPTION_SOURCE_ALL
  ["$OPTION_INSTALLATION_HOSTNAME"]=$OPTION_SOURCE_PROGRAM
  ["$OPTION_DATABASE_VERSION"]=$OPTION_SOURCE_ALL
  ["$OPTION_DATABASE_REPOSITORY"]=$OPTION_SOURCE_ALL
  ["$OPTION_DATABASE_PACKAGE_FILE_NAME"]=$OPTION_SOURCE_ALL
  ["$OPTION_DATABASE_OPATCH_FILE_NAME"]=$OPTION_SOURCE_ALL
  ["$OPTION_DATABASE_PATCH_FILE_NAME"]=$OPTION_SOURCE_ALL
  ["$OPTION_DATABASE_RESPONSE_FILE_NAME"]=$OPTION_SOURCE_ALL
  ["$OPTION_DATABASE_RESPONSE_FILE_PERMISSIONS"]=$OPTION_SOURCE_ALL
  ["$OPTION_DATABASE_BASE"]=$OPTION_SOURCE_PROGRAM
  ["$OPTION_DATABASE_HOME"]=$OPTION_SOURCE_PROGRAM
  ["$OPTION_DATABASE_DATA"]=$OPTION_SOURCE_ALL
  ["$OPTION_DATABASE_RECOVERY"]=$OPTION_SOURCE_ALL
  ["$OPTION_DATABASE_NAME"]=$OPTION_SOURCE_ALL
  ["$OPTION_DATABASE_PORT"]=$OPTION_SOURCE_ALL
  ["$OPTION_DATABASE_ADMINISTRATOR_GROUP"]=$OPTION_SOURCE_ALL
  ["$OPTION_DATABASE_PASSWORD"]=$OPTION_SOURCE_FILE
  ["$OPTION_MANAGER_VERSION"]=$OPTION_SOURCE_ALL
  ["$OPTION_MANAGER_REPOSITORY"]=$OPTION_SOURCE_ALL
  ["$OPTION_MANAGER_RESPONSE_FILE_NAME"]=$OPTION_SOURCE_ALL
  ["$OPTION_MANAGER_RESPONSE_FILE_PERMISSIONS"]=$OPTION_SOURCE_ALL
  ["$OPTION_MANAGER_BASE"]=$OPTION_SOURCE_PROGRAM
  ["$OPTION_MANAGER_HOME"]=$OPTION_SOURCE_PROGRAM
  ["$OPTION_MANAGER_INSTANCE"]=$OPTION_SOURCE_PROGRAM
  ["$OPTION_MANAGER_PORT"]=$OPTION_SOURCE_ALL
  ["$OPTION_MANAGER_PASSWORD"]=$OPTION_SOURCE_FILE
  ["$OPTION_MANAGER_KEYSTORE_FILE_NAME"]=$OPTION_SOURCE_ALL
  ["$OPTION_MANAGER_KEYSTORE_PASSWORD"]=$OPTION_SOURCE_FILE
  ["$OPTION_MANAGER_TRUSTSTORE_FILE_NAME"]=$OPTION_SOURCE_ALL
  ["$OPTION_MANAGER_TRUSTSTORE_PASSWORD"]=$OPTION_SOURCE_FILE
  ["$OPTION_AGENT_BASE"]=$OPTION_SOURCE_PROGRAM
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

# Option default values

declare -r DEFAULT_PASSWORD='Abcd_1234'
declare -r DEFAULT_DATABASE_PACKAGE_FILE_NAME='V982063-01.zip'
declare -r DEFAULT_DATABASE_OPATCH_FILE_NAME='p6880880_190000_Linux-x86-64.zip'
declare -r DEFAULT_DATABASE_PATCH_FILE_NAME='p35943157_190000_Linux-x86-64.zip'

declare -r -A OPTION_DEFAULT_VALUES=(
  ["$OPTION_REPOSITORY_ROOT"]='/mnt/MySQL/Software'
  ["$OPTION_REPOSITORY_ARCHIVE"]="${OPTION_DEFAULT_VALUES[${OPTION_REPOSITORY_ROOT}]}/archive"
  ["$OPTION_INSTALLATION_STAGE"]='/mnt/MySQL/Stage'
  ["$OPTION_INSTALLATION_ROOT"]='/u01/app'
  ["$OPTION_INSTALLATION_FILE_PERMISSIONS"]='755'
  ["$OPTION_INSTALLATION_USER"]='oracle'
  ["$OPTION_INSTALLATION_GROUP"]='oinstall'
  ["$OPTION_INSTALLATION_HOSTNAME"]=`hostname -f`
  ["$OPTION_DATABASE_VERSION"]='19.3.0.0.0'
  ["$OPTION_DATABASE_REPOSITORY"]="${OPTION_DEFAULT_VALUES[${OPTION_REPOSITORY_ROOT}]}/Oracle/${PRODUCT_DATABASE}/${OPTION_DEFAULT_VALUES[${OPTION_DATABASE_VERSION}]}"
  ["$OPTION_DATABASE_PACKAGE_FILE_NAME"]="${OPTION_DEFAULT_VALUES[${OPTION_REPOSITORY_ARCHIVE}]}/${DEFAULT_DATABASE_PACKAGE_FILE_NAME}"
  ["$OPTION_DATABASE_OPATCH_FILE_NAME"]="${OPTION_DEFAULT_VALUES[${OPTION_REPOSITORY_ARCHIVE}]}/${DEFAULT_DATABASE_OPATCH_FILE_NAME}"
  ["$OPTION_DATABASE_PATCH_FILE_NAME"]="${OPTION_DEFAULT_VALUES[${OPTION_REPOSITORY_ARCHIVE}]}/${DEFAULT_DATABASE_PATCH_FILE_NAME}"
  ["$OPTION_DATABASE_RESPONSE_FILE_NAME"]='/tmp/db_install.rsp'
  ["$OPTION_DATABASE_RESPONSE_FILE_PERMISSIONS"]='640'
  ["$OPTION_DATABASE_NAME"]='emrep'
  ["$OPTION_DATABASE_PORT"]='1521'
  ["$OPTION_DATABASE_ADMINISTRATOR_GROUP"]='dba'
  ["$OPTION_DATABASE_PASSWORD"]="$DEFAULT_PASSWORD"
  ["$OPTION_MANAGER_VERSION"]='13.5.0.0.0'
  ["$OPTION_MANAGER_REPOSITORY"]="${OPTION_DEFAULT_VALUES[${OPTION_REPOSITORY_ROOT}]}/Oracle/${PRODUCT_MANAGER}/${OPTION_DEFAULT_VALUES[${OPTION_MANAGER_VERSION}]}"
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
  ["$OPTION_SYSTEMD_SERVICE"]='dbora.service'
  ["$OPTION_SYSTEMD_FILE_NAME"]="/lib/systemd/system/${OPTION_DEFAULT_VALUES[${OPTION_SYSTEMD_SERVICE}]}"
  ["$OPTION_SYSTEMD_FILE_PERMISSIONS"]='644'
)

# Option descriptions

declare -r DESCRIPTION_SUDOERS_FILE="installation system user sudoers definition file"
declare -r DESCRIPTION_SWAP='system swap'
declare -r DESCRIPTION_SWAP_FILE="additional file for the ${DESCRIPTION_SWAP}"
declare -r DESCRIPTION_SYSCTL="Systemctl settings for the ${DESCRIPTION_PRODUCT_DATABASE}"
declare -r DESCRIPTION_SYSCTL_FILE="definition file for the ${DESCRIPTION_SYSCTL}"
declare -r DESCRIPTION_LIMITS="system limits settings for the ${DESCRIPTION_PRODUCT_DATABASE}"
declare -r DESCRIPTION_LIMITS_FILE="definition file for the ${DESCRIPTION_LIMITS}"
declare -r DESCRIPTION_CONTROLLER='service controller for the Oracle products'
declare -r DESCRIPTION_CONTROLLER_FILE="program file for ${DESCRIPTION_CONTROLLER}"
declare -r DESCRIPTION_SYSTEMD_SERVICE='Systemd service for the Oracle products'
declare -r DESCRIPTION_SYSTEMD_SERVICE_FILE="definition file for the ${DESCRIPTION_SYSTEMD_SERVICE}"
declare -r DESCRIPTION_DATABASE_PACKAGE_FILE="${DESCRIPTION_PRODUCT_DATABASE} software package zip file"
declare -r DESCRIPTION_DATABASE_OPATCH="${DESCRIPTION_PRODUCT_DATABASE} OPatch utility"
declare -r DESCRIPTION_DATABASE_OPATCH_FILE="${DESCRIPTION_DATABASE_OPATCH} update zip file"
declare -r DESCRIPTION_DATABASE_PATCH="${DESCRIPTION_PRODUCT_DATABASE} version patch update"
declare -r DESCRIPTION_DATABASE_PATCH_FILE="${DESCRIPTION_DATABASE_PATCH} zip file"
declare -r DESCRIPTION_DATABASE_RESPONSE_FILE="${DESCRIPTION_PRODUCT_DATABASE} installation response file"
declare -r DESCRIPTION_MANAGER_RESPONSE_FILE="${DESCRIPTION_PRODUCT_MANAGER} installation response file"
declare -r DESCRIPTION_MANAGER_KEYSTORE="${DESCRIPTION_PRODUCT_MANAGER} key store"
declare -r DESCRIPTION_MANAGER_KEYSTORE_FILE="${DESCRIPTION_MANAGER_KEYSTORE} file"
declare -r DESCRIPTION_MANAGER_TRUSTSTORE="${DESCRIPTION_PRODUCT_MANAGER} trust store"
declare -r DESCRIPTION_MANAGER_TRUSTSTORE_FILE="${DESCRIPTION_MANAGER_TRUSTSTORE} file"

declare -r -A OPTION_DESCRIPTIONS=(
  ["$OPTION_FILE"]='optional file that contains options to override the default option values of this program'
  ["$OPTION_REPOSITORY_ROOT"]='Oracle software repository root directory'
  ["$OPTION_REPOSITORY_ARCHIVE"]='directory that contains the Oracle software packages zip files'
  ["$OPTION_INSTALLATION_ROOT"]='Oracle installation root directory'
  ["$OPTION_INSTALLATION_STAGE"]='staging (de-)installation directory'
  ["$OPTION_INSTALLATION_INVENTORY"]='Oracle inventory directory'
  ["$OPTION_INSTALLATION_FILE_PERMISSIONS"]='file permissions of the Oracle installation'
  ["$OPTION_INSTALLATION_BASE"]='Oracle installation base directory'
  ["$OPTION_INSTALLATION_USER"]='installation system user'
  ["$OPTION_INSTALLATION_GROUP"]='installation system group'
  ["$OPTION_INSTALLATION_HOSTNAME"]='host name'
  ["$OPTION_DATABASE_VERSION"]="${DESCRIPTION_PRODUCT_DATABASE} version"
  ["$OPTION_DATABASE_REPOSITORY"]="${DESCRIPTION_PRODUCT_DATABASE} software repository directory"
  ["$OPTION_DATABASE_PACKAGE_FILE_NAME"]="name of the ${DESCRIPTION_DATABASE_PACKAGE_FILE}"
  ["$OPTION_DATABASE_OPATCH_FILE_NAME"]="name of the ${DESCRIPTION_DATABASE_OPATCH_FILE}"
  ["$OPTION_DATABASE_PATCH_FILE_NAME"]="name of the ${DESCRIPTION_DATABASE_PATCH_FILE}"
  ["$OPTION_DATABASE_RESPONSE_FILE_NAME"]="name of the ${DESCRIPTION_DATABASE_RESPONSE_FILE}"
  ["$OPTION_DATABASE_RESPONSE_FILE_PERMISSIONS"]="file permissions on the ${DESCRIPTION_DATABASE_RESPONSE_FILE}"
  ["$OPTION_DATABASE_BASE"]="${DESCRIPTION_PRODUCT_DATABASE} base directory"
  ["$OPTION_DATABASE_HOME"]="${DESCRIPTION_PRODUCT_DATABASE} home directory"
  ["$OPTION_DATABASE_DATA"]="${DESCRIPTION_PRODUCT_DATABASE} data directory"
  ["$OPTION_DATABASE_RECOVERY"]="${DESCRIPTION_PRODUCT_DATABASE} recovery directory"
  ["$OPTION_DATABASE_NAME"]="${DESCRIPTION_PRODUCT_DATABASE} name"
  ["$OPTION_DATABASE_PORT"]="${DESCRIPTION_PRODUCT_DATABASE} listener network port"
  ["$OPTION_DATABASE_ADMINISTRATOR_GROUP"]="${DESCRIPTION_PRODUCT_DATABASE} administrator system group"
  ["$OPTION_DATABASE_PASSWORD"]="${DESCRIPTION_PRODUCT_DATABASE} sys account password"
  ["$OPTION_MANAGER_VERSION"]="${DESCRIPTION_PRODUCT_MANAGER} version"
  ["$OPTION_MANAGER_REPOSITORY"]="${DESCRIPTION_PRODUCT_MANAGER} software repository directory"
  ["$OPTION_MANAGER_RESPONSE_FILE_NAME"]="name of the ${DESCRIPTION_MANAGER_RESPONSE_FILE}"
  ["$OPTION_MANAGER_RESPONSE_FILE_PERMISSIONS"]="file permissions on the ${DESCRIPTION_MANAGER_RESPONSE_FILE}"
  ["$OPTION_MANAGER_BASE"]="${DESCRIPTION_PRODUCT_MANAGER} base directory"
  ["$OPTION_MANAGER_HOME"]="${DESCRIPTION_PRODUCT_MANAGER} home directory"
  ["$OPTION_MANAGER_INSTANCE"]="${DESCRIPTION_PRODUCT_MANAGER} instance home directory"
  ["$OPTION_MANAGER_PORT"]="${DESCRIPTION_PRODUCT_MANAGER} network port"
  ["$OPTION_MANAGER_PASSWORD"]="${DESCRIPTION_PRODUCT_MANAGER} sysman account password"
  ["$OPTION_MANAGER_KEYSTORE_FILE_NAME"]="name of the ${OPTION_MANAGER_KEYSTORE_FILE}"
  ["$OPTION_MANAGER_KEYSTORE_PASSWORD"]="password for the ${OPTION_MANAGER_KEYSTORE_FILE}"
  ["$OPTION_MANAGER_TRUSTSTORE_FILE_NAME"]="name of the ${OPTION_MANAGER_TRUSTSTORE_FILE}"
  ["$OPTION_MANAGER_TRUSTSTORE_PASSWORD"]="password for the ${OPTION_MANAGER_TRUSTSTORE_FILE}"
  ["$OPTION_AGENT_BASE"]="${DESCRIPTION_PRODUCT_AGENT} base directory"
  ["$OPTION_AGENT_PASSWORD"]="${DESCRIPTION_PRODUCT_AGENT} account password"
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
    if [[ -n "$SourceName" ]] || [[ -n "$Default" ]] ; then
      if [[ -n "$SourceName" ]] && [[ -n "$Default" ]] ; then
        printf ' (source: %s; default=%s)' "$SourceName" "$Default"
      elif [[ -n "$SourceName" ]] ; then
        printf ' (source: %s)' "$SourceName"
      elif [[ -n "$Default" ]] ; then
        printf ' (default=%s)' "$Default"
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
  echo "A utility script to install and uninstall the ${DESCRIPTION_PRODUCT_DATABASE} and the ${DESCRIPTION_PRODUCT_MANAGER}."
  echo
  echo 'Commands:'
  for Item in "${COMMANDS[@]}" ; do
    echoHelpItem 'COMMAND_DESCRIPTIONS' "$Item"
  done
  echo
  echo "Products (only for the commands ${COMMAND_INSTALL} and ${COMMAND_UNINSTALL}):"
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
    echo "This program is designed for the simplified installation and uninstallation of ${DESCRIPTION_PRODUCT_DATABASE} 19c and ${DESCRIPTION_PRODUCT_MANAGER} 13cc on Oracle Linux 8.  A new Oracle Database instance is launched during the install process for immediate use by ${DESCRIPTION_PRODUCT_MANAGER}.  The installation is standardized without many options and is not designed to be bullet-proof."
    echo
    echo 'Detailed description:'
    echo "The Oracle software must be procured and provided to his program, by aid of the various program options, as zip files downloaded from Oracle eDelivery or My Oracle Support.  The program installs the Oracle products in their respective home directorie, the structure of which follows the guidelines of the Oracle Optimal Flexible Architecture (OFA) standard.  The installation of the software is performed using the ${OPTION_DESCRIPTIONS[${OPTION_INSTALLATION_USER}]} and the ${OPTION_DESCRIPTIONS[${OPTION_INSTALLATION_GROUP}]}.  If these ${OPTION_DESCRIPTIONS[${OPTION_INSTALLATION_USER}]} and ${OPTION_DESCRIPTIONS[${OPTION_INSTALLATION_GROUP}]} do not already exist on the system, the program automatically creates them.  The ${OPTION_DESCRIPTIONS[${OPTION_INSTALLATION_USER}]} is also automatically added to the operating system list of Sudoers, if it is not already in this list.  Many system settings are automatically adjusted as required by the ${DESCRIPTION_PRODUCT_DATABASE}.  The installation process is fully automated by use of the silent installer option of the Oracle software."
    echo
    echo 'Installation steps:'
    echo '1- Configure a machine that meets the minimum requirements listed below.'
    echo "2- Download the ${DESCRIPTION_PRODUCT_DATABASE} 19c package from https://edelivery.oracle.com or from https://support.oracle.com.  The package should consist of one zip file."
    echo "3- Download the latest ${DESCRIPTION_DATABASE_OPATCH} and ${DESCRIPTION_DATABASE_PATCH}."
    echo "4- Download the ${DESCRIPTION_PRODUCT_MANAGER} 13cc package from https://edelivery.oracle.com or from https://support.oracle.com.  The package should consist of five zip files.  Unzip the package files into a directory that will be used by this program as the ${OPTION_DESCRIPTIONS[${OPTION_MANAGER_REPOSITORY}]}.  The directory should contain a file with the name em13500_linux64.bin or one similar."
    echo '5- Run this program with the 'install' command and provide the two repository directory as options.  For example:'
    echo "     ./${PROGRAM} ${OPTION_PREFIX}${OPTION_DATABASE_PACKAGE_FILE_NAME}='/myoracle/software/repository/${DEFAULT_DATABASE_PACKAGE_FILE_NAME}' install"
    echo
    echo 'Minimum machine requirements:'
    echo '- CPUs: 2'
    echo '- Memory: 16GB'
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
## @param[out]    Message A message when an error has occurred while processing
##                        the program option.
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
      _Message="Invalid option: '${DisplayOption}'${Suffix}"
      if [[ $OPTION_SOURCE_PROGRAM -eq $Source ]] ; then
        Retcode=$RETCODE_INTERNAL_ERROR
      else
        Retcode=$RETCODE_PARAMETER_ERROR
      fi
    elif [[ $OPTION_SOURCE_COMMAND -eq $Source ]] && [[ $((Source & ${OPTION_SOURCES[$Option]})) -ne $Source ]] ; then
      _Message="Option not allowed on command line: '${DisplayOption}'${Suffix}"
      Retcode=$RETCODE_PARAMETER_ERROR
    elif [[ $OPTION_SOURCE_FILE -eq $Source ]] && [[ $((Source & ${OPTION_SOURCES[$Option]})) -ne $Source ]] ; then
      _Message="Option not allowed in configuration file: '${DisplayOption}'${Suffix}"
      Retcode=$RETCODE_PARAMETER_ERROR
    elif [[ -z "${_Sources[${Option}]}" ]] ; then
      _Sources["$Option"]=$Source
      _Values["$Option"]="$Value"
    elif [[ $OPTION_SOURCE_UNSET -eq $Source ]] ; then
      unset _Sources["$Option"]
      unset _Values["$Option"]
    elif [[ $OPTION_SOURCE_PROGRAM -ne $Source ]] && [[ $Source -eq ${_Sources[${Option}]} ]] ; then
      _Message="Option already set: '${DisplayOption}'${Suffix}"
      Retcode=$RETCODE_PARAMETER_ERROR
    fi
  fi
  return $Retcode
}

################################################################################
## @fn processOptionsFile
##
## @brief Read and process the program options in the file indicated by
##        OPTION_FILE.
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
  local -r File="${_Values[${OPTION_FILE}]}"
  local Content=''
  local Option=''
  local Value=''
  local -i Line=1

  if [[ $RETCODE_SUCCESS -ne $Retcode ]] ; then
    return $Retcode
  elif [[ -z "${_Sources[${OPTION_FILE}]}" ]] ; then # An option file has not been provided.
    return $RETCODE_SUCCESS
  elif [[ -z "$File" ]] ; then
    _Message="Configuration file not provided"
    return $RETCODE_PARAMETER_ERROR
  elif ! [[ -f "$File" ]] ; then
    _Message="Unable to find configuration file: ${File}"
    return $RETCODE_PARAMETER_ERROR
  elif ! [[ -r "$File" ]] ; then
    _Message="Unable to access configuration file: ${File}"
    return $RETCODE_PARAMETER_ERROR
  fi

  Content=$(sed -e 's/[[:space:]]*\=[[:space:]]*/=/g' \
                -e 's/#.*$//' \
                -e 's/[[:space:]]*$//' \
                -e 's/^[[:space:]]*//' \
                -e "s/^\(.*\)=\([^${CHARACTER_DOUBLE_QUOTE}${CHARACTER_SINGLE_QUOTE}]*\)$/\1=\2/" \
                < "$File")
  if [[ 0 -ne $? ]] ; then
    _Message="Error reading configuration file: ${File}"
    return $RETCODE_OPERATION_ERROR
  fi

  while IFS='=' read -r Option Value
  do
    if [[ -n "$Option" ]] ; then
      setOption $Retcode "$MessageName" "$SourcesName" "$ValuesName" $OPTION_SOURCE_FILE "$Option" "$Value" " (${File}:${Line})"
      Retcode=$?
    elif [[ -n "$Value" ]] ; then
      _Message="Unexpected value: '${Value}' (${File}:${Line})"
      Retcode=$RETCODE_PARAMETER_ERROR
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
      _RetrieveMessage=$(echoError $RETCODE_INTERNAL_ERROR 'value not provided for option' "$Option")
      Retcode=$?
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

################################ Main program functions ################################

################################################################################
## @fn displayOptions
##
## @brief Display the program options.
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
## @li Unzip of of the Oracle Database software to the Oracle Home directory.
## @li Unzip of of the Oracle OPatch utility update, if provided, to the
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
  local InstallationStage               DescriptionInstallationStage
  local InstallationInventory           DescriptionInstallationInventory
  local User                            DescriptionUser
  local Group                           DescriptionGroup
  local DatabaseRepository              DescriptionDatabaseRepository
  local DatabasePackageFileName         DescriptionDatabasePackageFileName
  local DatabaseOPatchFileName          DescriptionDatabaseOPatchFileName
  local DatabasePatchFileName           DescriptionDatabasePatchFileName
  local DatabaseResponseFileName        DescriptionDatabaseResponseFileName
  local DatabaseResponseFilePermissions DescriptionDatabaseResponseFilePermissions
  local DatabaseBase                    DescriptionDatabaseBase
  local DatabaseHome                    DescriptionDatabaseHome
  local DatabaseData                    DescriptionDatabaseData
  local DatabaseRecovery                DescriptionDatabaseRecovery
  local DatabaseName                    DescriptionDatabaseName
  local DatabasePassword                DescriptionDatabasePassword
  local SystemdService                  DescriptionSystemdService
  echoTitle "Installing the ${DESCRIPTION_PRODUCT_DATABASE}"
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_STAGE"                 'Message' 'InstallationStage'               'DescriptionInstallationStage'
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_INVENTORY"             'Message' 'InstallationInventory'           'DescriptionInstallationInventory'
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_USER"                  'Message' 'User'                            'DescriptionUser'
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_GROUP"                 'Message' 'Group'                           'DescriptionGroup'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_REPOSITORY"                'Message' 'DatabaseRepository'              'DescriptionDatabaseRepository'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_PACKAGE_FILE_NAME"         'Message' 'DatabasePackageFileName'         'DescriptionDatabasePackageFileName'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_OPATCH_FILE_NAME"          'Message' 'DatabaseOPatchFileName'          'DescriptionDatabaseOPatchFileName'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_PATCH_FILE_NAME"           'Message' 'DatabasePatchFileName'           'DescriptionDatabasePatchFileName'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_RESPONSE_FILE_NAME"        'Message' 'DatabaseResponseFileName'        'DescriptionDatabaseResponseFileName'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_RESPONSE_FILE_PERMISSIONS" 'Message' 'DatabaseResponseFilePermissions' 'DescriptionDatabaseResponseFilePermissions'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_BASE"                      'Message' 'DatabaseBase'                    'DescriptionDatabaseBase'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_HOME"                      'Message' 'DatabaseHome'                    'DescriptionDatabaseHome'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_DATA"                      'Message' 'DatabaseData'                    'DescriptionDatabaseData'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_RECOVERY"                  'Message' 'DatabaseRecovery'                'DescriptionDatabaseRecovery'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_NAME"                      'Message' 'DatabaseName'                    'DescriptionDatabaseName'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_PASSWORD"                  'Message' 'DatabasePassword'                'DescriptionDatabasePassword'
  retrieveOption $? "$1" "$2" "$OPTION_SYSTEMD_SERVICE"                    'Message' 'SystemdService'                  'DescriptionSystemdService'
  local -i Retcode=$?
  local -r OPatchHome="${DatabaseHome}/OPatch"
  local -r PatchHome="${InstallationStage}/database-patch"
  local -r DescriptionPatchHome="${DESCRIPTION_PRODUCT_DATABASE} patch update staging directory"
  local -r PatchFile="${Archive}/${DatabasePatchFileName}"
  local -r DescriptionPatchFile="${DESCRIPTION_PRODUCT_DATABASE} patch update file"
  local -r PatchNumber=$(basename "${DatabasePatchFileName}" | sed -r 's/p([0-9]*)_.*/\1/g')
  local -r InventoryInstaller="${InstallationInventory}/orainstRoot.sh"
  local -r DescriptionInventoryInstaller='Oracle Inventory root installer program'
  local -r DatabaseInstaller="${DatabaseHome}/runInstaller"
  local -r DescriptionDatabaseInstaller="${DESCRIPTION_PRODUCT_DATABASE} installer program"
  local -r DatabaseRootInstaller="${DatabaseHome}/root.sh"
  local -r DescriptionDatabaseRootInstaller="${DESCRIPTION_PRODUCT_DATABASE} root installer program"
  local -r Requirements="${DatabaseHome}/cv/admin/cvu_config"
  local -r Marker1="${DatabaseHome}/INSTALLATION_MARKER_1"
  local -r Marker1a="${DatabaseHome}/INSTALLATION_MARKER_1a"
  local -r Marker2="${DatabaseHome}/INSTALLATION_MARKER_2"
  local -r Marker3="${DatabaseHome}/INSTALLATION_MARKER_3"
  local -r Marker4="${DatabaseHome}/INSTALLATION_MARKER_4"
  local -r Marker5="${DatabaseHome}/INSTALLATION_MARKER_5"
  local -r Marker6="${DatabaseHome}/INSTALLATION_MARKER_6"
  local -r Marker7="${DatabaseHome}/INSTALLATION_MARKER_7"
  local -i bResponseCreated=$VALUE_FALSE
  local -i bPatchCreated=$VALUE_FALSE

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
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-r' "$DatabaseResponseFileName"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${DESCRIPTION_DATABASE_RESPONSE_FILE} already exists and will be overwritten" "$DatabaseResponseFileName"
    else
      echoCommandMessage "the ${DESCRIPTION_DATABASE_RESPONSE_FILE} does not exist" "$DatabaseResponseFileName"
    fi
    echoCommand 'sudo' '-u' "$User" '-g' "$Group" "cat > '${DatabaseResponseFileName}' <<EOF ... EOF"
    echo "cat > ${DatabaseResponseFileName} <<EOF
oracle.install.responseFileVersion=/oracle/install/rspfmt_dbinstall_response_schema_v19.0.0
oracle.install.option=INSTALL_DB_AND_CONFIG
UNIX_GROUP_NAME=${Group}
INVENTORY_LOCATION=${InstallationInventory}
ORACLE_HOME=${DatabaseHome}
ORACLE_BASE=${DatabaseBase}
oracle.install.db.InstallEdition=EE
oracle.install.db.OSDBA_GROUP=${Group}
oracle.install.db.OSBACKUPDBA_GROUP=${Group}
oracle.install.db.OSDGDBA_GROUP=${Group}
oracle.install.db.OSKMDBA_GROUP=${Group}
oracle.install.db.OSRACDBA_GROUP=${Group}
oracle.install.db.rootconfig.executeRootScript=false
oracle.install.db.rootconfig.configMethod=SUDO
oracle.install.db.rootconfig.sudoPath=`which sudo`
oracle.install.db.rootconfig.sudoUserName=${User}
oracle.install.db.config.starterdb.type=GENERAL_PURPOSE
oracle.install.db.config.starterdb.globalDBName=${Name}
oracle.install.db.config.starterdb.SID=${Name}
oracle.install.db.config.starterdb.characterSet=AL32UTF8
oracle.install.db.config.starterdb.memoryOption=false
oracle.install.db.config.starterdb.memoryLimit=2048
oracle.install.db.config.starterdb.installExampleSchemas=false
oracle.install.db.config.starterdb.password.ALL=${DatabasePassword}
oracle.install.db.config.starterdb.managementOption=DEFAULT
oracle.install.db.config.starterdb.enableRecovery=true
oracle.install.db.config.starterdb.storageType=FILE_SYSTEM_STORAGE
oracle.install.db.config.starterdb.fileSystemStorage.dataLocation=${DatabaseData}
oracle.install.db.config.starterdb.fileSystemStorage.recoveryLocation=${DatabaseRecovery}
EOF" | sudo '-u' "$User" '-g' "$Group" 'sh'
    processCommandCode $? "the ${DESCRIPTION_DATABASE_RESPONSE_FILE} was not created" "$DatabaseResponseFileName"
    Retcode=$?
    if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
      bResponseCreated=$VALUE_TRUE
    fi
  fi

  ### Restrict the file permissions of the response file. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' 'chmod' ${DatabaseResponseFilePermissions} "$DatabaseResponseFileName"
    processCommandCode $? "failed to restrict the ${DescriptionDatabaseResponseFilePermissions} to '${DatabaseResponseFilePermissions}'" "$DatabaseResponseFileName"
    Retcode=$?
  fi

  ### Validate that the response file is accessible by the installation user. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-r' "$DatabaseResponseFileName"
    processCommandCode $? "the ${DESCRIPTION_DATABASE_RESPONSE_FILE} does not exist or is inaccessible" "$DatabaseResponseFileName"
    Retcode=$?
  fi

  ######################################
  # Copy the Oracle Database software. #
  ######################################

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoSection "Copying of the ${DESCRIPTION_PRODUCT_DATABASE} software"
  fi

  ### Validate that the Oracle Database home directory can be written. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-d' "$DatabaseHome"
    processCommandCode $? "the ${DescriptionDatabaseHome} does not exist or is inaccessible" "$DatabaseHome"
    Retcode=$?
  fi

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-w' "$DatabaseHome"
    processCommandCode $? "the ${DescriptionDatabaseHome} is not writable" "$DatabaseHome"
    Retcode=$?
  fi

  ### Unzip the Oracle Database software package to the Oracle Database home directory. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$Marker1"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${DESCRIPTION_DATABASE_PACKAGE_FILE} ('${DatabasePackageFileName}') is already unzipped" "$DatabaseHome"
      Retcode=$?
    else
      echoCommandMessage "the ${DESCRIPTION_DATABASE_PACKAGE_FILE} ('${DatabasePackageFileName}') is not unzipped" "$DatabaseHome"
      executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-r' "$DatabasePackageFileName"
      processCommandCode $? "the ${DESCRIPTION_DATABASE_PACKAGE_FILE} does not exist or is inaccessible" "$DatabasePackageFileName"
      Retcode=$?
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'unzip' '-d' "$DatabaseHome" "$DatabasePackageFileName"
        processCommandCode $? "failed to unzip the ${DESCRIPTION_DATABASE_PACKAGE_FILE} (${DatabasePackageFileName}) using the user '${User}:${Group}' to '${DatabaseHome}'"
        Retcode=$?
        # Create indicator that the Oracle Database software has been unzipped.
        if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
          executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'touch' "$Marker1"
          processCommandCode $? 'failed to create the installation marker file' "$Marker1"
          Retcode=$?
        fi
      fi
    fi
  fi

  ### Unzip the Oracle Database OPatch utility update to the Oracle Database home directory. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ -n "$DatabaseOPatchFileName" ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$Marker1a"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${DESCRIPTION_DATABASE_OPATCH_FILE} ('${DatabaseOPatchFileName}') is already unzipped" "$OPatchHome"
      Retcode=$?
    else
      echoCommandMessage "the ${DESCRIPTION_DATABASE_OPATCH_FILE} ('${DatabaseOPatchFileName}') is not already unzipped" "$OPatchHome"
      executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-r' "$DatabaseOPatchFileName"
      processCommandCode $? "the ${DESCRIPTION_DATABASE_OPATCH_FILE} does not exist or is inaccessible" "$DatabaseOPatchFileName"
      Retcode=$?
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'mv' "$OPatchHome" "${OPatchHome}-original"
        processCommandCode $? "failed to move the original home of the ${DESCRIPTION_DATABASE_OPATCH} (${OPatchHome})" "${OPatchHome}-original"
        Retcode=$?
        if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
          executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'unzip' '-d' "$DatabaseHome" "$DatabaseOPatchFileName"
          processCommandCode $? "failed to unzip the ${DESCRIPTION_DATABASE_OPATCH_FILE} (${DatabaseOPatchFileName}) using the user '${User}:${Group}' to '${DatabaseHome}'"
          Retcode=$?
          # Create indicator that the OPatch utility update has been copied.
          if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
            executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'touch' "$Marker1a"
            processCommandCode $? 'failed to create the installation marker file' "$Marker1a"
            Retcode=$?
          fi
        fi
      fi
    fi
  fi

  ### Unzip the Oracle Database patch update to the staging directory. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ -n "$DatabasePatchFileName" ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "${PatchHome}/${PatchNumber}/README.txt"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${DESCRIPTION_DATABASE_PATCH_FILE} ('${DatabasePatchFileName}') is already unzipped" "${PatchHome}/${PatchNumber}"
      Retcode=$?
    else
      echoCommandMessage "the ${DESCRIPTION_DATABASE_PATCH_FILE} ('${DatabasePatchFileName}') is not already unzipped" "${PatchHome}/${PatchNumber}"
      executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-r' "$DatabasePatchFileName"
      processCommandCode $? "the ${DESCRIPTION_DATABASE_PATCH_FILE} does not exist or is inaccessible" "$DatabasePatchFileName"
      Retcode=$?
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'unzip' '-d' "$PatchHome" "$DatabasePatchFileName"
        processCommandCode $? "failed to unzip the ${DESCRIPTION_DATABASE_PATCH_FILE} (${DatabasePatchFileName}) using the user '${User}:${Group}' to '${PatchHome}'"
        Retcode=$?
        if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
          bPatchCreated=$VALUE_TRUE
        fi
      fi
    fi
  fi

return $Retcode

  ########################################
  # Installation of the Oracle Database. #
  ########################################

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoSection "Installation of the ${DESCRIPTION_PRODUCT_DATABASE}"
  fi

  ### Change the current working directory to the Oracle Database home directory. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    if [[ ! -d "$DatabaseHome" ]] || [[ ! -x "$DatabaseHome" ]] ; then
      echoError $RETCODE_OPERATION_ERROR "the ${DescriptionDatabaseHome} does not exist or is inaccessible" "$DatabaseHome"
    else
      echoCommand 'cd' "$DatabaseHome"
      cd "$DatabaseHome"
      processCommandCode $? "failed to change the current working directory to the ${DescriptionDatabaseHome}" "$DatabaseHome"
    fi
    Retcode=$?
  fi

  ### Export the ORACLE_HOME environment variable. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoCommand 'export' "ORACLE_HOME=${DatabaseHome}"
    export ORACLE_HOME="$DatabaseHome"
    processCommandCode $? "failed to export the ${DESCRIPTION_PRODUCT_DATABASE} environment variable ORACLE_HOME" "$DatabaseHome"
    Retcode=$?
  fi

  ### Export the CV_ASSUME_DISTID environment variable to enable installing on Oracle Linux 8 and 9. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    local -r CV_ASSUME_DISTID_VALUE='OEL8'
    echoCommand 'export' "CV_ASSUME_DISTID=${CV_ASSUME_DISTID_VALUE}"
    export CV_ASSUME_DISTID="$CV_ASSUME_DISTID_VALUE"
    processCommandCode $? "failed to export the ${DESCRIPTION_PRODUCT_DATABASE} environment variable CV_ASSUME_DISTID" "$CV_ASSUME_DISTID_VALUE"
    Retcode=$?
  fi

  ### Install the Oracle Database. ###

#  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
#    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$Marker2"
#    if [[ 0 -eq $? ]] ; then
#      echoCommandMessage "the ${DESCRIPTION_PRODUCT_DATABASE} is already installed" "$DatabaseHome"
#      Retcode=$?
#    else
#      echoCommandMessage "the ${DESCRIPTION_PRODUCT_DATABASE} is not already installed" "$DatabaseHome"
#      executeCommand 'sudo' '-E' '-u' "$User" '-g' "$Group" "${DatabaseInstaller}" '-silent' '-responseFile' "$DatabaseResponseFileName"
#      processCommandCode $? "an error occurred when running the ${DescriptionDatabaseInstaller}" "$DatabaseInstaller"
#      Retcode=$?
#      # Create indicator that the software has been installed.
#      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
#        executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'touch' "$Marker2"
#        processCommandCode $? 'failed to create the installation marker file' "$Marker2"
#        Retcode=$?
#      fi
#    fi
#  fi

  #######################################
  # Perform the post-installation steps #
  #######################################

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoSection "Post-installation steps"
  fi

  ### Run the Oracle inventory root installer program, if it exists, using the installation user. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$Marker3"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${DescriptionInventoryInstaller} has already been run" "$InventoryInstaller"
      Retcode=$?
    else
      echoCommandMessage "the ${DescriptionInventoryInstaller} has not already been run" "$InventoryInstaller"
      executeCommand 'sudo' '-E' '-u' "$User" '-g' "$Group" 'sudo' 'test' '-x' "$InventoryInstaller"
      if [[ 0 -eq $? ]] ; then
        echoCommandSuccess
        executeCommand 'sudo' '-E' '-u' "$User" '-g' "$Group" 'sudo' "$InventoryInstaller"
        processCommandCode $? "an error occurred when running the ${DescriptionInventoryInstaller}" "$InventoryInstaller"
        Retcode=$?
        # Create indicator that the Oracle Inventory root installer has been run.
        if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
          executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'touch' "$Marker3"
          processCommandCode $? 'failed to create the installation marker file' "$Marker3"
          Retcode=$?
        fi
      else
        echoCommandMessage "the ${DescriptionInventoryInstaller} does not exist or is inaccessible" "$InventoryInstaller"
        echoInfo "skipping running the ${DescriptionInventoryInstaller}" "$InventoryInstaller"
        Retcode=$?
      fi
    fi
  fi

  ### Run the Oracle Database root installer program using the installation user. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$Marker4"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${DescriptionDatabaseRootInstaller} has already been run" "$DatabaseRootInstaller"
      Retcode=$?
    else
      echoCommandMessage "the ${DescriptionDatabaseRootInstaller} has not already been run" "$DatabaseRootInstaller"
      executeCommand 'sudo' '-E' '-u' "$User" '-g' "$Group" 'sudo' 'test' '-x' "$DatabaseRootInstaller"
      processCommandCode $? "the ${DescriptionDatabaseRootInstaller} does not exist or is inaccessible" "$DatabaseRootInstaller"
      Retcode=$?
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'sudo' '-E' '-u' "$User" '-g' "$Group" 'sudo' '-E' "$DatabaseRootInstaller"
        processCommandCode $? "an error occurred when running the ${DescriptionDatabaseRootInstaller}" "$DatabaseRootInstaller"
        Retcode=$?
        # Create indicator that the Oracle Database root installer has been run.
        if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
          executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'touch' "$Marker4"
          processCommandCode $? 'failed to create the installation marker file' "$Marker4"
          Retcode=$?
        fi
      fi
    fi
  fi

  ### Configure the Oracle Database network settings using the installation user. ###

#  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
#    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$Marker5"
#    if [[ 0 -eq $? ]] ; then
#      echoCommandMessage "the network information of the ${DESCRIPTION_PRODUCT_DATABASE} is already configured"
#      Retcode=$?
#    else
#      echoCommandMessage "the network information of the ${DESCRIPTION_PRODUCT_DATABASE} is not configured"
#      executeCommand 'sudo' '-E' '-u' "$User" "$DatabaseInstaller" '-executeConfigTools' '-silent' '-responseFile' "$DatabaseResponseFileName"
#      processCommandCode $? "an error occurred when running the ${DescriptionDatabaseInstaller}" "${DatabaseInstaller} -executeConfigTools"
#      Retcode=$?
#      # Create indicator that the network information of the Oracle Database has been configured.
#      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
#        executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'touch' "$Marker5"
#        processCommandCode $? 'failed to create the installation marker file' "$Marker5"
#        Retcode=$?
#      fi
#    fi
#  fi

  ### Delete the Oracle Database automated installation response file. ###

  if [[ $VALUE_TRUE -eq $bResponseCreated ]] ; then
    executeCommand sudo '-u' "$User" '-g' "$Group" 'test' '-f' "$DatabaseResponseFileName"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${DESCRIPTION_DATABASE_RESPONSE_FILE} will be deleted" "$DatabaseResponseFileName"
      executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'rm' "$DatabaseResponseFileName"
      processCommandCode $? "failed to the delete the ${DESCRIPTION_DATABASE_RESPONSE_FILE}" "$DatabaseResponseFileName"
    else
      echoCommandMessage "the ${DESCRIPTION_DATABASE_RESPONSE_FILE} does not exist" "$DatabaseResponseFileName"
    fi
  fi

  ### Delete the Oracle Database patch update staging directory. ###

  if [[ $VALUE_TRUE -eq $bPatchCreated ]] ; then
    executeCommand sudo '-u' "$User" '-g' "$Group" 'test' '-d' "$PatchHome"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${DescriptionPatchHome} will be deleted" "$PatchHome"
      executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'rm' '-rf' "$PatchHome"
      processCommandCode $? "failed to the delete the ${DescriptionPatchHome}" "$PatchHome"
    else
      echoCommandMessage "the ${DescriptionPatchHome} does not exist" "$PatchHome"
    fi
  fi

  ### Modify the oratab file to enable the automatic start and shutdown of the database with dbstart and dbshut. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$Marker6"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the automatic start of the ${DESCRIPTION_PRODUCT_DATABASE} is already enabled"
      Retcode=$?
    else
      echoCommandMessage "the automatic start of the ${DESCRIPTION_PRODUCT_DATABASE} is not enabled"
      executeCommand 'sudo' 'test' '-f' "$ORATAB_FILE_NAME"
      if [[ 0 -eq $? ]] ; then
        echoCommandMessage "file exists" "$ORATAB_FILE_NAME"
        executeCommand 'sudo' 'sed' '-i' 's/:N$/:Y/' "$ORATAB_FILE_NAME"
        processCommandCode $? 'failed to modify the file' "$ORATAB_FILE_NAME"
        Retcode=$?
        # Create indicator that the automatic start of the Oracle Database has been enabled.
        if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
          executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'touch' "$Marker6"
          processCommandCode $? 'failed to create the installation marker file' "$Marker6"
          Retcode=$?
        fi
      else
        echoCommandMessage "file does not exist" "$ORATAB_FILE_NAME"
        Retcode=$?
      fi
    fi
  fi

return $Retcode

  ##
  ## Configuration of the Oracle Database.
  ##

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoSection "Configuration of the ${DESCRIPTION_PRODUCT_DATABASE}"
  fi

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$Marker7"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${DESCRIPTION_PRODUCT_DATABASE} is already configured" "$DatabaseName"
      Retcode=$?
    else
      echoCommandMessage "the ${DESCRIPTION_PRODUCT_DATABASE} is not configured" "$DatabaseName"

      # Change the current working directory to the Oracle Database home directory.

      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        echoCommand 'cd' "$DatabaseHome"
        cd "$DatabaseHome"
        processCommandCode $? "failed to change the current working directory to the ${DescriptionDatabaseHome}" "$DatabaseHome"
        Retcode=$?
      fi

      # Export the ORACLE_HOME environment variable.

      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        echoCommand 'export' "ORACLE_HOME=${DatabaseHome}"
        export ORACLE_HOME="$DatabaseHome"
        processCommandCode $? "failed to export the ${DESCRIPTION_PRODUCT_DATABASE} environment variable ORACLE_HOME" "$DatabaseHome"
        Retcode=$?
      fi

      # Configure the Oracle Database parameters required by Oracle Enterprise Manager.

      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'sudo' '-E' '-u' "$User" '-g' "$Group" "${DatabaseHome}/bin/sqlplus" '/nolog' <<EOF
CONNECT sys/${DatabasePassword}@${DatabaseName} AS sysdba
ALTER SYSTEM SET "_allow_insert_with_update_check"=true scope=both;
ALTER SYSTEM SET session_cached_cursors=200 scope=spfile;
ALTER SYSTEM SET shared_pool_size=600M scope=spfile;
ALTER SYSTEM SET processes=600 scope=spfile;
SHUTDOWN TRANSACTIONAL
EOF
        processCommandCode $? "failed to configure the ${DESCRIPTION_PRODUCT_DATABASE} parameters" "$DatabaseName"
        Retcode=$?
      fi

      # Restart the Oracle Database.

      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'sudo' 'systemctl' 'restart' "$SystemdService"
        processCommandCode $? "failed to restart the ${DescriptionSystemdService}" "$SystemdService"
        Retcode=$?
      fi

      # Create indicator that the Oracle Database has been configured.

      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'touch' "$Marker7"
        processCommandCode $? 'failed to create the installation marker file' "$Marker7"
        Retcode=$?
      fi
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
  local InstallationStage               DescriptionInstallationStage
  local InstallationInventory           DescriptionInstallationInventory
  local User                            DescriptionUser
  local Group                           DescriptionGroup
  local Hostname                        DescriptionHostname
  local DatabaseData                    DescriptionDatabaseData
  local DatabaseName                    DescriptionDatabaseName
  local DatabasePort                    DescriptionDatabasePort
  local DatabasePassword                DescriptionDatabasePassword
  local ManagerRepository               DescriptionManagerRepository
  local ManagerResponseFileName         DescriptionManagerResponseFileName
  local ManagerResponseFilePermissions  DescriptionManagerResponseFilePermissions
  local ManagerBase                     DescriptionManagerBase
  local ManagerHome                     DescriptionManagerHome
  local ManagerInstance                 DescriptionManagerInstance
  local ManagerPort                     DescriptionManagerPort
  local ManagerPassword                 DescriptionManagerPassword
  local ManagerKeystoreFileName         DescriptionManagerKeystoreFileName
  local ManagerKeystorePassword         DescriptionManagerKeystorePassword
  local ManagerTruststoreFileName       DescriptionManagerTruststoreFileName
  local ManagerTruststorePassword       DescriptionManagerTruststorePassword
  local AgentBase                       DescriptionAgentBase
  local AgentPassword                   DescriptionAgentPassword
  local WeblogicPort                    DescriptionWeblogicPort
  local WeblogicPassword                DescriptionWeblogicPassword
  local SystemdService                  DescriptionSystemdService
  echoTitle "Installing the ${DESCRIPTION_PRODUCT_MANAGER}"
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_STAGE"                'Message' 'InstallationStage'              'DescriptionInstallationStage'
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_INVENTORY"            'Message' 'InstallationInventory'          'DescriptionInstallationInventory'
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_USER"                 'Message' 'User'                           'DescriptionUser'
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_GROUP"                'Message' 'Group'                          'DescriptionGroup'
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_HOSTNAME"             'Message' 'Hostname'                       'DescriptionHostname'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_DATA"                     'Message' 'DatabaseData'                   'DescriptionDatabaseData'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_NAME"                     'Message' 'DatabaseName'                   'DescriptionDatabaseName'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_PORT"                     'Message' 'DatabasePort'                   'DescriptionDatabasePort'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_PASSWORD"                 'Message' 'DatabasePassword'               'DescriptionDatabasePassword'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_REPOSITORY"                'Message' 'ManagerRepository'              'DescriptionManagerRepository'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_RESPONSE_FILE_NAME"        'Message' 'ManagerResponseFileName'        'DescriptionManagerResponseFileName'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_RESPONSE_FILE_PERMISSIONS" 'Message' 'ManagerResponseFilePermissions' 'DescriptionManagerResponseFilePermissions'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_BASE"                      'Message' 'ManagerBase'                    'DescriptionManagerBase'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_HOME"                      'Message' 'ManagerHome'                    'DescriptionManagerHome'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_INSTANCE"                  'Message' 'ManagerInstance'                'DescriptionManagerInstance'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_PORT"                      'Message' 'ManagerPort'                    'DescriptionManagerPort'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_PASSWORD"                  'Message' 'ManagerPassword'                'DescriptionManagerPassword'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_KEYSTORE_FILE_NAME"        'Message' 'ManagerKeystoreFileName'        'DescriptionManagerKeystoreFileName'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_KEYSTORE_PASSWORD"         'Message' 'ManagerKeystorePassword'        'DescriptionManagerKeystorePassword'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_TRUSTSTORE_FILE_NAME"      'Message' 'ManagerTruststoreFileName'      'DescriptionManagerTruststoreFileName'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_TRUSTSTORE_PASSWORD"       'Message' 'ManagerTruststorePassword'      'DescriptionManagerTruststorePassword'
  retrieveOption $? "$1" "$2" "$OPTION_AGENT_BASE"                        'Message' 'AgentBase'                      'DescriptionAgentBase'
  retrieveOption $? "$1" "$2" "$OPTION_AGENT_PASSWORD"                    'Message' 'AgentPassword'                  'DescriptionAgentPassword'
  retrieveOption $? "$1" "$2" "$OPTION_WEBLOGIC_PORT"                     'Message' 'WeblogicPort'                   'DescriptionWeblogicPort'
  retrieveOption $? "$1" "$2" "$OPTION_WEBLOGIC_PASSWORD"                 'Message' 'WeblogicPassword'               'DescriptionWeblogicPassword'
  retrieveOption $? "$1" "$2" "$OPTION_SYSTEMD_SERVICE"                   'Message' 'SystemdService'                 'DescriptionSystemdService'
  local -i Retcode=$?
  local -r InstallationStage               DescriptionInstallationStage
  local -r InstallationInventory           DescriptionInstallationInventory
  local -r User                            DescriptionUser
  local -r Group                           DescriptionGroup
  local -r Hostname                        DescriptionHostname
  local -r DatabaseData                    DescriptionDatabaseData
  local -r DatabaseName                    DescriptionDatabaseName
  local -r DatabasePort                    DescriptionDatabasePort
  local -r DatabasePassword                DescriptionDatabasePassword
  local -r ManagerRepository               DescriptionManagerRepository
  local -r ManagerResponseFileName         DescriptionManagerResponseFileName
  local -r ManagerResponseFilePermissions  DescriptionManagerResponseFilePermissions
  local -r ManagerBase                     DescriptionManagerBase
  local -r ManagerHome                     DescriptionManagerHome
  local -r ManagerInstance                 DescriptionManagerInstance
  local -r ManagerPort                     DescriptionManagerPort
  local -r ManagerPassword                 DescriptionManagerPassword
  local -r ManagerKeystoreFileName         DescriptionManagerKeystoreFileName
  local -r ManagerKeystorePassword         DescriptionManagerKeystorePassword
  local -r ManagerTruststoreFileName       DescriptionManagerTruststoreFileName
  local -r ManagerTruststorePassword       DescriptionManagerTruststorePassword
  local -r AgentBase                       DescriptionAgentBase
  local -r AgentPassword                   DescriptionAgentPassword
  local -r WeblogicPort                    DescriptionWeblogicPort
  local -r WeblogicPassword                DescriptionWeblogicPassword
  local -r SystemdService                  DescriptionSystemdService
  local -r Marker1="${ManagerHome}/INSTALLATION_MARKER_1"
  local -r Marker2="${ManagerHome}/INSTALLATION_MARKER_2"
  local -r Marker3="${ManagerHome}/INSTALLATION_MARKER_3"
  local -r ManagerInstaller="${ManagerRepository}/em13500_linux64.bin"
  local -r DescriptionManagerInstaller="${DESCRIPTION_PRODUCT_MANAGER} installer program"
  local -r ManagerRootInstaller="${ManagerHome}/allroot.sh"
  local -r DescriptionDatabaseRootInstaller="${DESCRIPTION_PRODUCT_DATABASE} root installer program"
  local -r ManagerData="${ManagerBase}/oradata"
  local -i bCreated=$VALUE_FALSE

return $Retcode

  ##
  ## Generation of the Oracle Enterprise Manager automated installation response file.
  ##

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoSection "Generation of the ${DESCRIPTION_MANAGER_RESPONSE_FILE}"
  fi

  # Generate the response file.

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand sudo '-u' "$User" '-g' "$Group" 'test' '-r' "$ManagerResponseFileName"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "The ${DESCRIPTION_MANAGER_RESPONSE_FILE} already exists and will be overwritten" "$ManagerResponseFileName"
    else
      echoCommandMessage "The ${DESCRIPTION_MANAGER_RESPONSE_FILE} does not exist" "$ManagerResponseFileName"
    fi
    echoCommand 'sudo' '-u' "$User" '-g' "$Group" "cat > '${ManagerResponseFileName}' <<EOF ... EOF"
    echo "cat > '${ManagerResponseFileName}' <<EOF
RESPONSEFILE_VERSION=2.2.1.0.0
UNIX_GROUP_NAME=${Group}
# Installation
INSTALL_UPDATES_SELECTION=skip
b_upgrade=false
EM_INSTALL_TYPE=NOSEED
CONFIGURATION_TYPE=ADVANCED
EMPREREQ_AUTO_CORRECTION=yes
CONFIGURE_ORACLE_SOFTWARE_LIBRARY=false
INVENTORY_LOCATION=${InstallationInventory}
# Weblogic
ORACLE_MIDDLEWARE_HOME_LOCATION=${ManagerHome}
ORACLE_HOSTNAME=${Hostname}
WLS_ADMIN_SERVER_USERNAME=weblogic
WLS_ADMIN_SERVER_PASSWORD=${WeblogicPassword}
WLS_ADMIN_SERVER_CONFIRM_PASSWORD=${WeblogicPassword}
NODE_MANAGER_PASSWORD=${WeblogicPassword}
NODE_MANAGER_CONFIRM_PASSWORD=${WeblogicPassword}
ORACLE_INSTANCE_HOME_LOCATION=${ManagerInstance}
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
    processCommandCode $? "The ${DESCRIPTION_MANAGER_RESPONSE_FILE} was not created" "$ManagerResponseFileName"
    Retcode=$?
    if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
      bCreated=$VALUE_TRUE
    fi
  fi

  # Restrict the file permissions of the response file.

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' 'chmod' ${ManagerResponseFilePermissions} "$ManagerResponseFileName"
    processCommandCode $? "Failed to restrict the file permissions to ${DescriptionManagerResponseFilePermissions} on the ${DESCRIPTION_MANAGER_RESPONSE_FILE}" "$ManagerResponseFileName"
    Retcode=$?
  fi

  # Validate that the response file is accessible by the installation user.

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-r' "$ManagerResponseFileName"
    processCommandCode $? "the ${DESCRIPTION_MANAGER_RESPONSE_FILE} is inaccessible" "$ManagerResponseFileName"
    Retcode=$?
  fi

  ##
  ## Installation of the Oracle Enterprise Manager.
  ##

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoSection "Installation of the ${DESCRIPTION_PRODUCT_MANAGER}"
  fi

  # Change the current working directory to the Oracle Enterprise Manager software repository.

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    if [[ ! -d "$ManagerRepository" ]] || [[ ! -x "$ManagerRepository" ]] ; then
      echoError $RETCODE_OPERATION_ERROR "the ${DescriptionManagerRepository} does not exist or is inaccessible" "$ManagerRepository"
    else
      echoCommand 'cd' "$ManagerRepository"
      cd "$ManagerRepository"
      processCommandCode $? "failed to change the current working directory to the ${DescriptionManagerRepository}" "$ManagerRepository"
    fi
    Retcode=$?
  fi

  # Export the ORACLE_HOME environment variable.

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoCommand 'export' "ORACLE_HOME=${ManagerHome}"
    export ORACLE_HOME="$ManagerHome"
    processCommandCode $? 'failed to export the environment variable ORACLE_HOME' "$ManagerHome"
    Retcode=$?
  fi

  # Export the OMS_INSTANCE_HOME environment variable.

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoCommand 'export' "OMS_INSTANCE_HOME=${ManagerInstance}"
    export OMS_INSTANCE_HOME="$ManagerInstance"
    processCommandCode $? 'failed to export the environment variable OMS_INSTANCE_HOME' "$ManagerInstance"
    Retcode=$?
  fi

  # Run the Oracle Enterprise Manager installer program using the installation user.

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$Marker1"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${DESCRIPTION_PRODUCT_MANAGER} software is already installed" "$ManagerHome"
      Retcode=$?
    else
      echoCommandMessage "the ${DESCRIPTION_PRODUCT_MANAGER} software is not already installed" "$ManagerHome"
      executeCommand sudo '-E' '-u' "$User" '-g' "$Group" "$ManagerInstaller" '-silent' '-responseFile' "$ManagerResponseFileName" "-J-Djava.io.tmpdir=${InstallationStage}"
      processCommandCode $? "an error occurred when running the ${DescriptionManagerInstaller}" "$ManagerInstaller"
      Retcode=$?
      # Create indicator that the Oracle Enterprise Manager has been installed.
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'touch' "$Marker1"
        processCommandCode $? 'failed to create the installation marker file' "$Marker1"
        Retcode=$?
      fi
    fi
  fi

  ##
  ## Perform the post-installation steps
  ##

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoSection "Post-installation steps"
  fi

  # Delete the Oracle Enterprise Manager automated installation response file.

  if [[ $VALUE_TRUE -eq $bCreated ]] ; then
    executeCommand sudo '-u' "$User" '-g' "$Group" 'test' '-f' "$ManagerResponseFileName"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${DESCRIPTION_MANAGER_RESPONSE_FILE} will be deleted" "$ManagerResponseFileName"
      executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'rm' "$ManagerResponseFileName"
      processCommandCode $? "failed to the delete the ${DESCRIPTION_MANAGER_RESPONSE_FILE}" "$ManagerResponseFileName"
    else
      echoCommandMessage "the ${DESCRIPTION_MANAGER_RESPONSE_FILE} does not exist" "$ManagerResponseFileName"
    fi
  fi

  # Run the Oracle Enterprise Manager root installer program using the root user.

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$Marker2"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${DescriptionManagerRootInstaller} has already been run" "$ManagerRootInstaller"
      Retcode=$?
    else
      echoCommandMessage "the ${DescriptionManagerRootInstaller} has not already been run" "$ManagerRootInstaller"
      executeCommand 'sudo' '-E' '-u' "$User" '-g' "$Group" 'sudo' 'test' '-x' "$ManagerRootInstaller"
      processCommandCode $? "the ${DescriptionManagerRootInstaller} does not exist or is inaccessible" "$ManagerRootInstaller"
      Retcode=$?
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'sudo' '-E' '-u' "$User" '-g' "$Group" 'sudo' '-E' "$ManagerRootInstaller"
        processCommandCode $? "an error occurred when running the ${DescriptionManagerRootInstaller}" "$ManagerRootInstaller"
        Retcode=$?
        # Create indicator that the Oracle Enterprise Manager root installer program has been run.
        if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
          executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'touch' "$Marker2"
          processCommandCode $? "failed to create the installation marker file" "$Marker2"
          Retcode=$?
        fi
      fi
    fi
  fi

  # Configure firewalld to allow network access to the Oracle Enterprise Manager.

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$Marker3"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "Firewalld has already been configured for the ${DESCRIPTION_PRODUCT_MANAGER}"
      Retcode=$?
    else
      echoCommandMessage "Firewalld has not already been configured for the ${DESCRIPTION_PRODUCT_MANAGER}"
      executeCommand 'sudo' 'systemctl' 'status' 'firewalld'
      if [[ 0 -eq $? ]] ; then
        echoCommandSuccess
        executeCommand 'sudo' 'firewall-cmd' '--permanent' '--zone=public' "--add-port=${WeblogicPort}/tcp"
        processCommandCode $? "failed to allow public access to the ${DescriptionWeblogicPort}" "$WeblogicPort"
        Retcode=$?
        if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
          executeCommand 'sudo' 'firewall-cmd' '--permanent' '--zone=public' "--add-port=${ManagerPort}/tcp"
          processCommandCode $? "failed to allow public access to the ${DescriptionManagerPort}" "$ManagerPort"
          Retcode=$?
        fi
        if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
          executeCommand 'sudo' 'firewall-cmd' '--reload'
          processCommandCode $? 'failed to reload firewalld'
          Retcode=$?
          # Create indicator that Firewalld has been configured for the Oracle Enterprise Manager.
          if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
            executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'touch' "$Marker3"
            processCommandCode $? "failed to create the installation marker file" "$Marker3"
            Retcode=$?
          fi
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
  local InstallationInventory     DescriptionInstallationInventory
  local InstallationBase          DescriptionInstallationBase
  local InstallationPermissions   DescriptionInstallationPermissions
  local User                      DescriptionUser
  local Group                     DescriptionGroup
  local DatabaseHome              DescriptionDatabaseHome
  local DBAGroup                  DescriptionDBAGroup
  local ManagerHome               DescriptionManagerHome
  local ManagerInstance           DescriptionManagerInstance
  local AgentBase                 DescriptionAgentBase
  local SudoersFileName           DescriptionSudoersFileName
  local SudoersFilePermissions    DescriptionSudoersFilePermissions
  local SwapGoal                  DescriptionSwapGoal
  local SwapFileName              DescriptionSwapFileName
  local SwapFilePermissions       DescriptionSwapFilePermissions
  local SysctlFileName            DescriptionSysctlFileName
  local SysctlFilePermissions     DescriptionSysctlFilePermissions
  local LimitsFileName            DescriptionLimitsFileName
  local LimitsFilePermissions     DescriptionLimitsFilePermissions
  local ControlLerFileName        DescriptionControllerFileName
  local ControlLerFilePermissions DescriptionControllerFilePermissions
  local SystemdService            DescriptionSystemdService
  local SystemdFileName           DescriptionSystemdFileName
  local SystemdFilePermissions    DescriptionSystemdFilePermissions
  echoTitle 'Preparing for installation of the Oracle products'
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_INVENTORY"        'Message' 'InstallationInventory'     'DescriptionInstallationInventory'
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_BASE"             'Message' 'InstallationBase'          'DescriptionInstallationBase'
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_FILE_PERMISSIONS" 'Message' 'InstallationPermissions'   'DescriptionInstallationPermissions'
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_USER"             'Message' 'User'                      'DescriptionUser'
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_GROUP"            'Message' 'Group'                     'DescriptionGroup'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_HOME"                 'Message' 'DatabaseHome'              'DescriptionDatabaseHome'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_ADMINISTRATOR_GROUP"  'Message' 'DBAGroup'                  'DescriptionDBAGroup'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_HOME"                  'Message' 'ManagerHome'               'DescriptionManagerHome'
  retrieveOption $? "$1" "$2" "$OPTION_MANAGER_INSTANCE"              'Message' 'ManagerInstance'           'DescriptionManagerInstance'
  retrieveOption $? "$1" "$2" "$OPTION_AGENT_BASE"                    'Message' 'AgentBase'                 'DescriptionAgentBase'
  retrieveOption $? "$1" "$2" "$OPTION_SUDOERS_FILE_NAME"             'Message' 'SudoersFileName'           'DescriptionSudoersFileName'
  retrieveOption $? "$1" "$2" "$OPTION_SUDOERS_FILE_PERMISSIONS"      'Message' 'SudoersFilePermissions'    'DescriptionSudoersFilePermissions'
  retrieveOption $? "$1" "$2" "$OPTION_SWAP_GOAL"                     'Message' 'SwapGoal'                  'DescriptionSwapGoal'
  retrieveOption $? "$1" "$2" "$OPTION_SWAP_FILE_NAME"                'Message' 'SwapFileName'              'DescriptionSwapFileName'
  retrieveOption $? "$1" "$2" "$OPTION_SWAP_FILE_PERMISSIONS"         'Message' 'SwapFilePermissions'       'DescriptionSwapFilePermissions'
  retrieveOption $? "$1" "$2" "$OPTION_SYSCTL_FILE_NAME"              'Message' 'SysctlFileName'            'DescriptionSysctlFileName'
  retrieveOption $? "$1" "$2" "$OPTION_SYSCTL_FILE_PERMISSIONS"       'Message' 'SysctlFilePermissions'     'DescriptionSysctlFilePermissions'
  retrieveOption $? "$1" "$2" "$OPTION_LIMITS_FILE_NAME"              'Message' 'LimitsFileName'            'DescriptionLimitsFileName'
  retrieveOption $? "$1" "$2" "$OPTION_LIMITS_FILE_PERMISSIONS"       'Message' 'LimitsFilePermissions'     'DescriptionLimitsFilePermissions'
  retrieveOption $? "$1" "$2" "$OPTION_CONTROLLER_FILE_NAME"          'Message' 'ControllerFileName'        'DescriptionControllerFileName'
  retrieveOption $? "$1" "$2" "$OPTION_CONTROLLER_FILE_PERMISSIONS"   'Message' 'ControllerFilePermissions' 'DescriptionControllerFilePermissions'
  retrieveOption $? "$1" "$2" "$OPTION_SYSTEMD_SERVICE"               'Message' 'SystemdService'            'DescriptionSystemdService'
  retrieveOption $? "$1" "$2" "$OPTION_SYSTEMD_FILE_NAME"             'Message' 'SystemdFileName'           'DescriptionSystemdFileName'
  retrieveOption $? "$1" "$2" "$OPTION_SYSTEMD_FILE_PERMISSIONS"      'Message' 'SystemdFilePermissions'    'DescriptionSystemdFilePermissions'
  local -i Retcode=$?

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
      executeCommand2 'Capture' 'sudo' '/usr/sbin/groupadd' '-g' '54321' "$Group"
      processCommandCode $? "failed to create the ${DescriptionGroup}" "$Group" "$Capture"
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
      executeCommand2 'Capture' 'sudo' '/usr/sbin/groupadd' '-g' '54322' "$DBAGroup"
      processCommandCode $? "failed to create the ${DescriptionDBAGroup}" "$DBAGroup" "$Capture"
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
      executeCommand2 'Capture' 'sudo' '/usr/sbin/useradd' '-u' '54321' '-g' "$Group" '–s' '/usr/sbin/nologin' "$User"
      processCommandCode $? "failed to create the ${DescriptionUser}" "${User}:${Group}" "$Capture"
      Retcode=$?
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
      if [[ 0 -eq $? ]] || [[ "$DBAGroup" == "$Output4" ]] ; then
        echoCommandMessage "the ${DescriptionUser} '${User}' is already a member of the ${DescriptionDBAGroup}" "$DBAGroup"
      else
        echoCommandMessage "the ${DescriptionUser} '${User}' is not a member of the ${DescriptionDBAGroup}" "$DBAGroup" "$Output4"
        executeCommand2 'Capture' 'sudo' 'usermod' '-a' '-G' "$DBAGroup" "$User"
        if [[ 0 -eq $? ]] ; then
          echoSuccess
        else
          echoInfo "failed to add the ${DescriptionUser} '${User}' to the ${DescriptionDBAGroup}" "$DBAGroup" "$Capture"
        fi
      fi
      Retcode=$?
    fi
  fi

  ### Retrieve the home directory of the installation user. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    local -r UserHome="$(getent 'passwd' ${User} | cut '-d:' '-f6')"
    if [[ -z "$UserHome" ]] ; then
      echoError $RETCODE_PARAMETER_ERROR "failed to determine the home directory of the ${DescriptionUser}" "$User"
      Retcode=$?
    else
      executeCommand2 'Capture' 'sudo' '-u' "$User" '-g' "$Group" 'test' '-d' "$UserHome"
      processCommandCode $? "failed to access the home directory of the ${DescriptionUser} (${User})" "$UserHome"
      Retcode=$?
    fi
  fi

  ### Add the installation user to the operating systems's list of sudoers. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand2 'Capture' 'sudo' 'test' '-r' "$SudoersFileName"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${DESCRIPTION_SUDOERS_FILE} already exists" "$SudoersFileName" "$Capture"
      Retcode=$?
    else
      echoCommandMessage "the ${DESCRIPTION_SUDOERS_FILE} does not exist" "$SudoersFileName" "$Capture"
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
    executeCommand 'sudo' 'yum' '-y' 'install' 'libnsl'
    processCommandCode $? 'failed to install the pre-requisite system library' 'libnsl'
    Retcode=$?
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
    SwapString=`sudo swapon '--show' '--raw' '--noheadings' | awk '-F' ' ' 'BEGIN{ Total = 0} { if ( "G" == substr($3,length($3),1) ) Total+=substr($3,1,length($3)-1) } END{ print Total }'`
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
          executeCommand2 'Capture' 'sudo' '/sbin/sysctl' '-p' "$SysctlFileName"
          processCommandCode $? "failed to activate ${DESCRIPTION_SYSCT_FILE}" "$SysctlFileName" "$Capture"
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

  ### Create the installation inventory directory. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" -g "$Group" 'test' '-d' "$InstallationInventory"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${DescriptionInstallationInventory} already exists" "$InstallationInventory"
      Retcode=$?
    else
      echoCommandMessage "the ${DescriptionInstallationInventory} does not exist" "$InstallationInventory"
      executeCommand 'sudo' 'mkdir' '-m' "$InstallationPermissions" '-p' "$InstallationInventory"
      processCommandCode $? "failed to create the ${DescriptionInstallationInventory}" "$InstallationInventory"
      Retcode=$?
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'sudo' 'chown' "${User}:${Group}" "$InstallationInventory"
        processCommandCode $? "failed to set the ownership of the ${DescriptionInstallationInventory} to '${User}:${Group}'" "$InstallationInventory"
        Retcode=$?
      fi
    fi
  fi

  ### Create the installation base directory. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-d' "$InstallationBase"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${DescriptionInstallationBase} already exists" "$InstallationBase"
      Retcode=$?
    else
      echoCommandMessage "the ${DescriptionInstallationBase} does not exist" "$InstallationBase"
      executeCommand 'sudo' 'mkdir' '-m' "$InstallationPermissions" '-p' "$InstallationBase"
      processCommandCode $? "failed to create the ${DescriptionInstallationBase}" "$InstallationBase"
      Retcode=$?
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'sudo' 'chown' "${User}:${Group}" "$InstallationBase"
        processCommandCode $? "failed to set the ownership of the ${DescriptionInstallationBase} to '${User}:${Group}'" "$InstallationBase"
        Retcode=$?
      fi
    fi
  fi

  ### Create the Oracle Database home directory. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-d' "$DatabaseHome"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${DescriptionDatabaseHome} already exists" "$DatabaseHome"
    else
      echoCommandMessage "the ${DescriptionDatabaseHome} does not exist" "$DatabaseHome"
      executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'mkdir' '-m' "$InstallationPermissions" '-p' "$DatabaseHome"
      processCommandCode $? "failed to create the ${DescriptionDatabaseHome}" "$DatabaseHome"
    fi
    Retcode=$?
  fi

  ### Create the Oracle Enterprise Manager home directory. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-d' "$ManagerHome"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${DescriptionManagerHome} already exists" "$ManagerHome"
    else
      echoCommandMessage "the ${DescriptionManagerHome} does not exist" "$ManagerHome"
      executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'mkdir' '-m' "$InstallationPermissions" '-p' "$ManagerHome"
      processCommandCode $? "failed to create the ${DescriptionManagerHome}" "$ManagerHome"
    fi
    Retcode=$?
  fi

  ### Create the Oracle Enterprise Manager instance home directory. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-d' "$ManagerInstance"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${DescriptionManagerInstance} already exists" "$ManagerInstance"
    else
      echoCommandMessage "the ${DescriptionManagerInstance} does not exist" "$ManagerInstance"
      executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'mkdir' '-m' "$InstallationPermissions" '-p' "$ManagerInstance"
      processCommandCode $? "failed to create the ${DescriptionManagerInstance}" "$ManagerInstance"
    fi
    Retcode=$?
  fi

  ### Create the Oracle Enterprise Manager agent base directory. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-d' "$AgentBase"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "the ${DescriptionAgentBase} already exists" "$AgentBase"
    else
      echoCommandMessage "the ${DescriptionAgentBase} does not exist" "$AgentBase"
      executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'mkdir' '-m' "$InstallationPermissions" '-p' "$AgentBase"
      processCommandCode $? "failed to create the ${DescriptionAgentBase}" "$AgentBase"
    fi
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
ExecStart=/usr/bin/bash -c '${ControlFile} start'
ExecStop=/usr/bin/bash -c '${ControlFile} stop'

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
  echoTitle "Uninstalling the ${DESCRIPTION_PRODUCT_DATABASE}"
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_USER"  'Message' 'User'
  retrieveOption $? "$1" "$2" "$OPTION_INSTALLATION_GROUP" 'Message' 'Group'
  retrieveOption $? "$1" "$2" "$OPTION_DATABASE_HOME"      'Message' 'DatabaseHome' 'DescriptionDatabaseHome'
  local -i Retcode=$?
  local -r User
  local -r Group
  local -r DatabaseHome
  local -r DescriptionDatabaseHome
  local -r DatabaseDeinstaller="${DatabaseHome}/deinstall/deinstall"
  local -r DescriptionDatabaseDeinstaller="${DESCRIPTION_PRODUCT_DATABASE} de-installer program"
  local DatabaseResponseFileName=''
  local -r DescriptionDatabaseResponseFileName="${DESCRIPTION_PRODUCT_DATABASE} de-installation response file"

  ###########################################################
  # Preparation for de-installation of the Oracle Database. #
  ###########################################################

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoSection "Preparation for de-installation of the ${DESCRIPTION_PRODUCT_DATABASE}"
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
    processCommandCode $? "failed to export the ${DESCRIPTION_PRODUCT_DATABASE} environment variable CV_ASSUME_DISTID" "$CV_ASSUME_DISTID_VALUE"
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
      DatabaseResponseFileName=$(echo "$Right" | awk -F "$CHARACTER_SINGLE_QUOTE" '{ print $2 }')
      if [[ -z "$DatabaseResponseFileName" ]] ; then
        echoError $RETCODE_OPERATION_ERROR "failed to obtain a ${DescriptionDatabaseResponseFileName} from the ${DescriptionDatabaseDeinstaller}" "$DatabaseDeinstaller"
      else
        echoCommandMessage "${DescriptionDatabaseResponseFileName}" "$DatabaseResponseFileName"
      fi
    else
      echoError $Retcode "failed to generate a ${DescriptionDatabaseResponseFileName} with the ${DescriptionDatabaseDeinstaller}" "$DatabaseDeinstaller"
    fi
    Retcode=$?
  fi

  ### Validate that the automated uninstallation response file is present and accessible to the installation user. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-E' '-u' "$User" '-g' "$Group" 'test' '-r' "$DatabaseResponseFileName"
    processCommandCode $? "the ${DescriptionDatabaseResponseFileName} does not exist or is inaccessible" "$DatabaseResponseFileName"
    Retcode=$?
  fi

  ###########################################
  # De-installation of the Oracle Database. #
  ###########################################

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoSection "De-installation of the ${DESCRIPTION_PRODUCT_DATABASE}"
  fi

  ### Uninstall the Oracle Database software. ###

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-E' '-u' "$User" '-g' "$Group" "$DatabaseDeinstaller" '-silent' '-paramfile' "$DatabaseResponseFileName"
    processCommandCode $? "an error occurred when running the ${DescriptionDatabaseDeinstaller}" "$DatabaseDeinstaller" "response file" "$DatabaseResponseFileName"
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
  echoTitle "Uninstalling the ${DESCRIPTION_PRODUCT_MANAGER}"
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
  local -r DescriptionDatabaseDeinstaller="${DESCRIPTION_PRODUCT_MANAGER} de-installer program"

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

setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_REPOSITORY_ROOT"              "${OPTION_DEFAULT_VALUES[${OPTION_REPOSITORY_ROOT}]}"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_REPOSITORY_ARCHIVE"           "${OptionValues[${OPTION_REPOSITORY_ROOT}]}/archive"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_INSTALLATION_ROOT"            "${OPTION_DEFAULT_VALUES[${OPTION_INSTALLATION_ROOT}]}"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_INSTALLATION_USER"            "${OPTION_DEFAULT_VALUES[${OPTION_INSTALLATION_USER}]}"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_INSTALLATION_BASE"            "${OptionValues[${OPTION_INSTALLATION_ROOT}]}/${OptionValues[${OPTION_INSTALLATION_USER}]}"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_INSTALLATION_INVENTORY"       "${OptionValues[${OPTION_INSTALLATION_ROOT}]}/oraInventory"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_DATABASE_VERSION"             "${OPTION_DEFAULT_VALUES[${OPTION_DATABASE_VERSION}]}"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_DATABASE_NAME"                "${OPTION_DEFAULT_VALUES[${OPTION_DATABASE_NAME}]}"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_DATABASE_REPOSITORY"          "${OptionValues[${OPTION_REPOSITORY_ROOT}]}/${PRODUCT_DATABASE}/${OptionValues[${OPTION_DATABASE_VERSION}]}"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_DATABASE_PACKAGE_FILE_NAME"   "${OptionValues[${OPTION_REPOSITORY_ARCHIVE}]}/${DEFAULT_DATABASE_PACKAGE_FILE_NAME}"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_DATABASE_OPATCH_FILE_NAME"    "${OptionValues[${OPTION_REPOSITORY_ARCHIVE}]}/${DEFAULT_DATABASE_OPATCH_FILE_NAME}"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_DATABASE_PATCH_FILE_NAME"     "${OptionValues[${OPTION_REPOSITORY_ARCHIVE}]}/${DEFAULT_DATABASE_PATCH_FILE_NAME}"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_DATABASE_BASE"                "${OptionValues[${OPTION_INSTALLATION_BASE}]}/${PRODUCT_DATABASE}"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_DATABASE_HOME"                "${OptionValues[${OPTION_DATABASE_BASE}]}/product/${OptionValues[${OPTION_DATABASE_VERSION}]}/dbhome_1"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_DATABASE_DATA"                "${OptionValues[${OPTION_DATABASE_BASE}]}/oradata/${OptionValues[${OPTION_DATABASE_NAME}]}"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_DATABASE_RECOVERY"            "${OptionValues[${OPTION_DATABASE_BASE}]}/recovery/${OptionValues[${OPTION_DATABASE_NAME}]}"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_MANAGER_VERSION"              "${OPTION_DEFAULT_VALUES[${OPTION_MANAGER_VERSION}]}"
setOption $? 'Message' 'OptionSources' 'OptionValues' $OPTION_SOURCE_PROGRAM "$OPTION_MANAGER_REPOSITORY"           "${OptionValues[${OPTION_REPOSITORY_ROOT}]}/${PRODUCT_MANAGER}/${OptionValues[${OPTION_MANAGER_VERSION}]}"
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
      echo 'System preparation failed: ${Retcode}'
    fi
    ;;
  "$COMMAND_INSTALL")
    if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
      echo 'Installation successful'
      if [[ -z "$COMMAND_TARGET" ]] || [[ "$PRODUCT_DATABASE" == "$COMMAND_TARGET" ]] ; then
        echo "Environment variables for the ${DESCRIPTION_PRODUCT_DATABASE}"
        echo "ORACLE_BASE=${OptionValues[${OPTION_DATABASE_BASE}]}"
        echo "ORACLE_HOME=${OptionValues[${OPTION_DATABASE_HOME}]}"
      fi
      if [[ -z "$COMMAND_TARGET" ]] || [[ "$PRODUCT_MANAGER" == "$COMMAND_TARGET" ]] ; then
        echo "Environment variables for the ${DESCRIPTION_PRODUCT_MANAGER}"
        echo "ORACLE_BASE=${OptionValues[${OPTION_MANAGER_BASE}]}"
        echo "ORACLE_HOME=${OptionValues[${OPTION_MANAGER_HOME}]}"
      fi
    else
      echo 'Installation failed: ${Retcode}'
    fi
    ;;
  "$COMMAND_UNINSTALL")
    if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
      echo 'Uninstallation successful'
    else
      echo 'Uninstallation failed: ${Retcode}'
    fi
    ;;
  *)
    ;;
esac

exit $Retcode
