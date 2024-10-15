#!/usr/bin/bash
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

####################
# Program commands #
####################

declare -r COMMAND_HELP='help'
declare -r COMMAND_OPTIONS='options'
declare -r COMMAND_INSTALL='install'
declare -r COMMAND_UNINSTALL='uninstall'

#######################
# Product information #
#######################

declare -r PRODUCT_DATABASE='database'
declare -r PRODUCT_MANAGER='em'
declare -r PRODUCT_AGENT='emagent'
declare -r DESCRIPTION_PRODUCT_DATABASE='Oracle Database'
declare -r DESCRIPTION_PRODUCT_MANAGER='Oracle Enterprise Manager'
declare -r DESCRIPTION_PRODUCT_AGENT='Oracle Enterprise Manager Agent'

###################
# Program options #
###################

declare OPTION_INSTALLATION_REPOSITORY='repository'
declare OPTION_INSTALLATION_ROOT='root'
declare OPTION_INSTALLATION_USER='user'
declare OPTION_INSTALLATION_GROUP='group'
declare OPTION_DATABASE_VERSION='database-version'
declare OPTION_DATABASE_NAME='database'
declare OPTION_MANAGER_VERSION='manager-version'

##########################################################
# Program options and function parameters default values #
##########################################################

declare -r DEFAULT_INSTALLATION_REPOSITORY='/mnt/MySQL/Software/Oracle'
declare -r DEFAULT_INSTALLATION_STAGE='/mnt/MySQL/Stage'
declare -r DEFAULT_INSTALLATION_ROOT='/u01/app'
declare -r DEFAULT_INSTALLATION_USER='oracle'
declare -r DEFAULT_INSTALLATION_GROUP='oinstall'
declare -r DEFAULT_INSTALLATION_HOSTNAME=`hostname -f`
declare -r DEFAULT_DATABASE_VERSION='19.3.0.0.0'
declare -r DEFAULT_DATABASE_NAME='emrep'
declare -r DEFAULT_DATABASE_PASSWORD='Abcd_1234'
declare -r DEFAULT_DATABASE_RESPONSE='/tmp/db_install.rsp'
declare -r DEFAULT_MANAGER_VERSION='13.5.0.0.0'
declare -r DEFAULT_MANAGER_RESPONSE='/tmp/em_install.rsp'
declare -r -i DEFAULT_PORT_DATABASE=1521
declare -r -i DEFAULT_PORT_MANAGER=7803
declare -r -i DEFAULT_PORT_WEBLOGIC=7102

########################################################
# Program options and function parameters descriptions #
########################################################

declare -r DESCRIPTION_INSTALLATION_REPOSITORY='Oracle software repository directory'
declare -r DESCRIPTION_INSTALLATION_STAGE='Staging (de-)installation directory'
declare -r DESCRIPTION_INSTALLATION_ROOT='Oracle installation root directory'
declare -r DESCRIPTION_INSTALLATION_INVENTORY='Oracle inventory directory'
declare -r DESCRIPTION_INSTALLATION_BASE='Oracle installation base directory'
declare -r DESCRIPTION_INSTALLATION_USER='installation user'
declare -r DESCRIPTION_INSTALLATION_GROUP='installation group'
declare -r DESCRIPTION_INSTALLATION_HOSTNAME='installation host name'
declare -r DESCRIPTION_DATABASE_VERSION="${DESCRIPTION_PRODUCT_DATABASE} version"
declare -r DESCRIPTION_DATABASE_REPOSITORY="${DESCRIPTION_PRODUCT_DATABASE} software repository directory"
declare -r DESCRIPTION_DATABASE_BASE="${DESCRIPTION_PRODUCT_DATABASE} base directory"
declare -r DESCRIPTION_DATABASE_HOME="${DESCRIPTION_PRODUCT_DATABASE} home directory"
declare -r DESCRIPTION_DATABASE_NAME="${DESCRIPTION_PRODUCT_DATABASE} name"
declare -r DESCRIPTION_DATABASE_DATA="${DESCRIPTION_PRODUCT_DATABASE} data directory"
declare -r DESCRIPTION_DATABASE_RECOVERY="${DESCRIPTION_PRODUCT_DATABASE} recovery directory"
declare -r DESCRIPTION_DATABASE_RESPONSE="${DESCRIPTION_PRODUCT_DATABASE} response file"
declare -r DESCRIPTION_MANAGER_REPOSITORY="${DESCRIPTION_PRODUCT_MANAGER} software repository directory"
declare -r DESCRIPTION_MANAGER_BASE="${DESCRIPTION_PRODUCT_MANAGER} base directory"
declare -r DESCRIPTION_MANAGER_HOME="${DESCRIPTION_PRODUCT_MANAGER} home directory"
declare -r DESCRIPTION_MANAGER_INSTANCE="${DESCRIPTION_PRODUCT_MANAGER} instance home directory"
declare -r DESCRIPTION_MANAGER_VERSION="${DESCRIPTION_PRODUCT_MANAGER} version"
declare -r DESCRIPTION_MANAGER_RESPONSE="${DESCRIPTION_PRODUCT_MANAGER} response file"
declare -r DESCRIPTION_AGENT_BASE="${DESCRIPTION_PRODUCT_AGENT} base directory"
declare -r DESCRIPTION_SUDOERS_FILE="${DESCRIPTION_INSTALLATION_USER} sudoers supplementary file"
declare -r DESCRIPTIOM_SYSTEMD_SERVICE="Systemd service for the ${DESCRIPTION_PRODUCT_DATABASE}"
declare -r DESCRIPTIOM_SYSTEMD_FILE="Systemd service file for the ${DESCRIPTION_PRODUCT_DATABASE}"
declare -r DESCRIPTION_CONTROL_FILE="${DESCRIPTION_PRODUCT_DATABASE} service control program"

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

declare -r -i VALUE_TRUE=0
declare -r -i VALUE_FALSE=1
declare -r -i HELP_INDENT_LENGTH=2
declare -r -i HELP_PADDING_LENGTH=24
declare -r -i DESCRIPTION_LENGTH=56
declare -r -i CACHE_GOAL=16 # In gigabytes
declare -r SUDOERS_FILE_NAME='/etc/sudoers.d/101-oracle-user'
declare -r SUDOERS_FILE_PERMISSIONS='440'
declare -r CACHE_FILE_NAME='/.swapfile_oem'
declare -r CACHE_FILE_PERMISSIONS='600'
declare -r CONTROL_FILE_NAME='database.sh'
declare -r CONTROL_FILE_PERMISSIONS='740'
declare -r SYSTEMD_NAME='dbora.service'
declare -r SYSTEMD_FILE_NAME="/lib/systemd/system/${SYSTEMD_NAME}"
declare -r SYSTEMD_FILE_PERMISSIONS='644'
declare -r ORACLE_DIRECTORY_PERMISSIONS='755'
declare -r RESPONSE_FILE_PERMISSIONS='640'
declare -r ORATAB_FILE_NAME='/etc/oratab'

################################ Utility functions ################################

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
## @param[in] Message The message to echo.
##
## @return RETCODE_SUCCESS
################################################################################
echoCommandMessage() {
  local -r Message="${1:-}"
  if [[ -n "$Message" ]] ; then
    echo "...${Message^}"
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
## @param[in] Retcode The return code.
## @param[in] Message The message to echo.
##
## @return The return code.
################################################################################
echoError() {
  local -r DEFAULT_MESSAGE='Unexpected error'
  local -r -i Retcode=${1:-$RETCODE_INTERNAL_ERROR}
  local -r Message="${2:-${DEFAULT_MESSAGE}}"
  if [[ $RETCODE_SUCCESS -ne $Retcode ]] ; then
    echo "[ERROR] ${Message^}"
  fi
  return $Retcode
}

################################################################################
## @fn echoHelpCommand
##
## @brief Echo the description of a program command formatted for the help
##        command.
##
## @param[in] Command     The program command.
## @param[in] Description The description of the command.
##
## @return RETCODE_SUCCESS
################################################################################
echoHelpCommand() {
  local -r Command="${1:-}"
  local -r Description="${2:-}"
  if [[ -n "$Command" ]] ; then
    local -r -i Padding=$(($HELP_PADDING_LENGTH - ${#Command}))
    printf ' %.0s' $(seq 1 $HELP_INDENT_LENGTH)
    printf '%s: ' "$Command"
    if [[ 0 -lt $Padding ]] ; then
      printf ' %.0s' $(seq 1 $Padding)
    fi
    printf '%s.' "$Description"
    echo
  fi
  return $RETCODE_SUCCESS
}

################################################################################
## @fn echoHelpOption
##
## @brief Echo the description of a program option formatted for the help
##        command.
##
## @param[in] Option      The program option.
## @param[in] Description The description of the option.
## @param[in] Default     An optional default value for the option.
##
## @return RETCODE_SUCCESS
################################################################################
echoHelpOption() {
  local -r Option="${1:-}"
  local -r Description="${2:-}"
  local -r Default="${3:-}"
  if [[ -n "$Option" ]] ; then
    local -r -i Padding=$(($HELP_PADDING_LENGTH - ${#Option} - 2))
    printf ' %.0s' $(seq 1 $HELP_INDENT_LENGTH)
    printf '%s%s: ' '--' "$Option"
    if [[ 0 -lt $Padding ]] ; then
      printf ' %.0s' $(seq 1 $Padding)
    fi
    printf '%s' "$Description"
    if [[ -n "$Default" ]] ; then
      printf ' (default=%s)' "$Default"
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
## @param[in] Complete Whether to display the complete help or only the usage
##            portion (0: Usage only, 1: Complete help)
##
## @return RETCODE_SUCCESS
################################################################################
echoHelp() {
  local -r -i Complete=${1:-0}
  echo "Usage: ${PROGRAM} [options...] < ${COMMAND_HELP} | ${COMMAND_OPTIONS} | ${COMMAND_INSTALL} | ${COMMAND_UNINSTALL} >"
  echo "A utility script to install and uninstall the ${DESCRIPTION_PRODUCT_DATABASE} and the ${DESCRIPTION_PRODUCT_MANAGER}."
  echo
  echo 'Commands:'
  if [[ 1 -eq $1 ]] ; then
    echoHelpCommand "$COMMAND_HELP" 'Display this help'
  else
    echoHelpCommand "$COMMAND_HELP" 'Display the program help'
  fi
  echoHelpCommand "$COMMAND_OPTIONS" 'Display the program parameters'
  echoHelpCommand "$COMMAND_INSTALL" "Install the ${DESCRIPTION_PRODUCT_DATABASE} and ${DESCRIPTION_PRODUCT_MANAGER}"
  echoHelpCommand "$COMMAND_UNINSTALL" "Uninstall the ${DESCRIPTION_PRODUCT_DATABASE} and ${DESCRIPTION_PRODUCT_MANAGER}"
  echo
  echo 'Options:'
  echoHelpOption "$OPTION_INSTALLATION_REPOSITORY" "$DESCRIPTION_INSTALLATION_REPOSITORY" "$DEFAULT_INSTALLATION_REPOSITORY"
  echoHelpOption "$OPTION_INSTALLATION_ROOT" "$DESCRIPTION_INSTALLATION_ROOT" "$DEFAULT_INSTALLATION_ROOT"
  echoHelpOption "$OPTION_INSTALLATION_USER" "$DESCRIPTION_INSTALLATION_USER" "$DEFAULT_INSTALLATION_USER"
  echoHelpOption "$OPTION_INSTALLATION_GROUP" "$DESCRIPTION_INSTALLATION_GROUP" "$DEFAULT_INSTALLATION_GROUP"
  echoHelpOption "$OPTION_DATABASE_VERSION" "$DESCRIPTION_DATABASE_VERSION" "$DEFAULT_DATABASE_VERSION"
  echoHelpOption "$OPTION_DATABASE_NAME" "$DESCRIPTION_DATABASE_NAME" "$DEFAULT_DATABASE_NAME"
  echoHelpOption "$OPTION_MANAGER_VERSION" "$DESCRIPTION_MANAGER_VERSION" "$DEFAULT_MANAGER_VERSION"
  echo
  if [[ 1 -eq $1 ]] ; then
    echo 'Summary:'
    echo "This program is designed for the simplified installation and uninstallation of ${DESCRIPTION_PRODUCT_DATABASE} 19c and ${DESCRIPTION_PRODUCT_MANAGER} 13cc on Oracle Linux 8.  A new database is launched during the install process for immediate use.  The installation is standardized without many options and should not be regarded as being bullet-proof."
    echo
    echo 'Detailed description:'
    echo "The Oracle Database software must be separately procured and unzipped in a directory that is referred by this program as the ${DESCRIPTION_DATABASE_REPOSITORY}.  The program copies the Oracle Database software from the repository to the ${DESCRIPTION_DATABASE_HOME^}, and installs it using the ${DESCRIPTION_INSTALLATION_USER} and the ${DESCRIPTION_INSTALLATION_GROUP}.  If these do not already exist on the system, the program automatically creates them.  The ${DESCRIPTION_INSTALLATION_USER} is also automatically added to the operating system list of Sudoers, if it is not already in this list.  An ${DESCRIPTION_DATABASE_RESPONSE} is generated, unless it already exists, but it is not removed upon termination of the program to allow for diagnosis.  Note that a default database password is hard-coded in cleartext in the response file.  The ${DESCRIPTION_INSTALLATION_BASE^}, as well as the ${DESCRIPTION_INSTALLATION_INVENTORY^}, are determined by the program by using the ${DESCRIPTION_INSTALLATION_ROOT} and following the guidelines of the Oracle Optimal Flexible Architecture."
    echo
  fi
  return $RETCODE_SUCCESS
}

################################################################################
## @fn echoInfo
##
## @brief Echo an informational message.
##
## @param[in] Message The message to echo.
##
## @return RETCODE_SUCCESS
################################################################################
echoInfo() {
  local -r Message="${1:-}"
  if [[ -n "$Message" ]] ; then
    echo "[INFO] ${Message^}"
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
## @param[in] Tag    An optional tag to display before the option.
##
## @return RETCODE_SUCCESS
################################################################################
echoOption() {
  local -r Option="${1:-}"
  local -r Value="${2:-}"
  local -r Tag="${3:-}"
  if [[ -n "$Option" ]] ; then
    local -r -i Padding=$(($DESCRIPTION_LENGTH - ${#Option}))
    if [[ -n "$Tag" ]] ; then
      printf '[%s] ' "$Tag"
    fi
    printf '%s:' "${Option^}"
    if [[ -n "$Value" ]] ; then
      if [[ 0 -lt $Padding ]] ; then
        printf ' %.0s' $(seq 1 $Padding)
      fi
      printf ' %s' "$Value"
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
## @fn processCommandCode
##
## @brief Process the exit code of a command.
##
## @param[in] ExitCode The exit code.
## @param[in] Message  A mesage to display if the exit code denotes an error.
##
## @return The exit code.
################################################################################
processCommandCode() {
  local -r -i ExitCode=${1:-$RETCODE_INTERNAL_ERROR}
  local -r Message="${2:-}"
  if [[ $RETCODE_SUCCESS -eq $ExitCode ]] ; then
    echoCommandSuccess
  else
    echoError $ExitCode "$Message"
  fi
  return $?
}

################################################################################
## @fn setOption
##
## @brief Set the value of a variable that represents a program option and echo
##        error messages, if any.
##
## @param[in]     Option       The name of the program option.
## @param[in]     Value        The new value of the option.
## @param[in,out] Variable     The name of the variable to set the value.  An
##                             error is returned when the value has already been
##                             been set, unless the value of the parameter
##                             KeepExisting is true.
## @param[in]     Retcode      A return code that causes the function to return
##                             immediately when the code denotes an error.  The
##                             default value of this parameter is
##                             RETCODE_SUCCESS.
## @param[in]     KeepExisting If the variable already has a non-empty value,
##                             return successfully without changing the value of
##                             the variable when this parameter is true, or
##                             generate an error when it is false (default).
##
## @return The value of the parameter Retcode if it denotes an error, or
##         otherwise the return code of the function execution.
################################################################################
setOption() {
  local DummyVariable=''
  local -r Option="$1"
  local -r Value="${2:-}"
  local -n Variable="${3:-DummyVariable}"
  local -r -i Retcode=${4:-$RETCODE_SUCCESS}
  local -r -i KeepExisting=${5:-$VALUE_FALSE}
  if [[ $RETCODE_SUCCESS -ne $Retcode ]] ; then
    return $Retcode
  elif [[ -n "$Variable" ]] ; then
    if [[ $VALUE_FALSE -eq $KeepExisting ]] ; then
      echoError $RETCODE_PARAMETER_ERROR "Option already set: --${Option}"
      return $?
    else
      return $RETCODE_SUCCESS
    fi
  elif [[ -z "$Value" ]] ; then
    echoError $RETCODE_PARAMETER_ERROR "Option value is empty: --${Option}"
    return $?
  else
    Variable="$Value"
    return $RETCODE_SUCCESS
  fi
}

################################################################################
## @fn traceParameter
##
## @brief Echo a function parameter and its value as a trace message.  Trace
##        messages are only echoed if the variable ECHO_TRACE is true.  Validate
##        that the value of the parameter is not empty.
##
## @param[in] Retcode   A return code that causes the function to return
##                      immediately when the code indicates an error.
## @param[in] Parameter The parameter.
## @param[in] Value     The value of the parameter.
##
## @return The value of the parameter Retcode if it denotes an error, or
##         RETCODE_INTERNAL_ERROR if the value of the parameter is empty, or
##         otherwise RETCODE_SUCCESS.
################################################################################
traceParameter() {
  local -i Retcode=$1
  local -r Parameter="${2:-}"
  local -r Value="${3:-}"
  if [[ $RETCODE_SUCCESS -ne $Retcode ]] ; then
    return $Retcode
  elif [[ $ECHO_TRACE ]] ; then
    echoOption "$Parameter" "$Value" 'TRACE'
    Retcode=$?
  fi
  if [[ -z "$Value" ]] ; then
    echoError $RETCODE_INTERNAL_ERROR "${Parameter} not provided"
    Retcode=$?
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
  echoTitle 'Program options'
  echoOption "$DESCRIPTION_DATABASE_VERSION" "$DATABASE_VERSION"
  echoOption "$DESCRIPTION_MANAGER_VERSION" "$MANAGER_VERSION"
  echoOption "$DESCRIPTION_INSTALLATION_REPOSITORY" "$INSTALLATION_REPOSITORY"
  echoOption "$DESCRIPTION_DATABASE_REPOSITORY" "$DATABASE_REPOSITORY"
  echoOption "$DESCRIPTION_MANAGER_REPOSITORY" "$MANAGER_REPOSITORY"
  echoOption "$DESCRIPTION_INSTALLATION_BASE" "$INSTALLATION_BASE"
  echoOption "$DESCRIPTION_INSTALLATION_INVENTORY" "$INSTALLATION_INVENTORY"
  echoOption "$DESCRIPTION_INSTALLATION_USER" "$INSTALLATION_USER"
  echoOption "$DESCRIPTION_INSTALLATION_GROUP" "$INSTALLATION_GROUP"
  echoOption "$DESCRIPTION_INSTALLATION_HOSTNAME" "$INSTALLATION_HOSTNAME"
  echoOption "$DESCRIPTION_DATABASE_BASE" "$DATABASE_BASE"
  echoOption "$DESCRIPTION_DATABASE_HOME" "$DATABASE_HOME"
  echoOption "$DESCRIPTION_DATABASE_NAME" "$DATABASE_NAME"
  echoOption "$DESCRIPTION_DATABASE_DATA" "$DATABASE_DATA"
  echoOption "$DESCRIPTION_DATABASE_RECOVERY" "$DATABASE_RECOVERY"
  echoOption "$DESCRIPTION_MANAGER_BASE" "$MANAGER_BASE"
  echoOption "$DESCRIPTION_MANAGER_HOME" "$MANAGER_HOME"
  echoOption "$DESCRIPTION_MANAGER_INSTANCE" "$MANAGER_INSTANCE"
  echoOption "$DESCRIPTION_AGENT_BASE" "$AGENT_BASE"
  echoOption "$DESCRIPTION_DATABASE_RESPONSE" "$DATABASE_RESPONSE"
  echoOption "$DESCRIPTION_MANAGER_RESPONSE" "$MANAGER_RESPONSE"
  return $RETCODE_SUCCESS
}

################################################################################
## @fn installDatabase
##
## @brief Install and launch the Oracle Database (Listener + Starter database).
##
## @param[in] Inventory  The inventory directory of the Oracle installation
##                       (ex. /u01/app/oraInventory).
## @param[in] User       The installation user.
## @param[in] Group      The installation group.
## @param[in] Repository The source directory from which to copy the Oracle
##                       Database software.
## @param[in] Base       The base directory of the Oracle Database.
##                       (ex. /u01/app/oracle/database).
## @param[in] Home       The home directory of the Oracle Database.
##                       (ex. /u01/app/oracle/database/product/xxxx/dbhome_1).
## @param[in] Name       The name of the database.
## @param[in] Data       The data directory of the Oracle Database.
## @param[in] Recovery   The recovery directory of the Oracle Database.
## @param[in] Password   The password for the database "sys" account.
## @param[in] Response   The filename of the response file to generate. An
##                       existing response file will be overwritten.
##
## @note This function performs the following steps:
##
## @li Generation of a response file for the automated installation of the
##     Oracle Database.
## @li Copy of the Oracle Database software to the Oracle Home directory.
## @li Modification of the installation requirements to allow Oracle linux 8.1
##     and higher.
## @li Installation of the Oracle Database by running the Oracle installer
##     program runInstaller.
## @li Execution of the orainstRoot.sh and root.sh scripts.
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
  local -r Inventory="${1:-}"
  local -r User="${2:-}"
  local -r Group="${3:-}"
  local -r Repository="${4:-}"
  local -r Base="${5:-}"
  local -r Home="${6:-}"
  local -r Name="${7:-}"
  local -r Data="${8:-}"
  local -r Recovery="${9:-}"
  local -r Password="${10:-}"
  local -r Response="${11:-}"
  local -r InventoryInstaller="${Inventory}/orainstRoot.sh"
  local -r DatabaseInstaller="${Home}/root.sh"
  local -r Requirements="${Home}/cv/admin/cvu_config"
  local -r Marker1="${Home}/INSTALLATION_MARKER_1"
  local -r Marker2="${Home}/INSTALLATION_MARKER_2"
  local -r Marker3="${Home}/INSTALLATION_MARKER_3"
  local -r Marker4="${Home}/INSTALLATION_MARKER_4"
  local -r Marker5="${Home}/INSTALLATION_MARKER_5"
  local -r Marker6="${Home}/INSTALLATION_MARKER_6"
  local -r Marker7="${Home}/INSTALLATION_MARKER_7"
  local -i Created=1
  local -i Retcode=$RETCODE_SUCCESS

  echoTitle "Installing the ${DESCRIPTION_PRODUCT_DATABASE}"

  traceParameter $Retcode "$DESCRIPTION_INSTALLATION_INVENTORY" "$Inventory"
  retcode=$?
  traceParameter $Retcode "$DESCRIPTION_INSTALLATION_USER" "$User"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_INSTALLATION_GROUP" "$Group"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_DATABASE_BASE" "$Base"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_DATABASE_HOME" "$Home"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_DATABASE_NAME" "$Name"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_DATABASE_DATA" "$Data"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_DATABASE_RECOVERY" "$Recovery"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_DATABASE_RESPONSE" "$Response"
  Retcode=$?

  ##
  ## Generation of the Oracle Database automated installation response file.
  ##

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoSection "Generation of the ${DESCRIPTION_DATABASE_RESPONSE}"
  fi

  # Generate the response file.

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-r' "$Response"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "The ${DESCRIPTION_DATABASE_RESPONSE} already exists and will be overwritten: ${Response}"
    else
      echoCommandMessage "The ${DESCRIPTION_DATABASE_RESPONSE} was not found: ${Response}"
    fi
    echoCommand 'sudo' '-u' "$User" '-g' "$Group" "cat > ${Response} <<EOF ... EOF"
    echo "cat > ${Response} <<EOF
oracle.install.responseFileVersion=/oracle/install/rspfmt_dbinstall_response_schema_v19.0.0
oracle.install.option=INSTALL_DB_AND_CONFIG
UNIX_GROUP_NAME=${Group}
INVENTORY_LOCATION=${Inventory}
ORACLE_HOME=${Home}
ORACLE_BASE=${Base}
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
oracle.install.db.config.starterdb.password.ALL=${Password}
oracle.install.db.config.starterdb.managementOption=DEFAULT
oracle.install.db.config.starterdb.enableRecovery=true
oracle.install.db.config.starterdb.storageType=FILE_SYSTEM_STORAGE
oracle.install.db.config.starterdb.fileSystemStorage.dataLocation=${Data}
oracle.install.db.config.starterdb.fileSystemStorage.recoveryLocation=${Recovery}
EOF" | sudo '-u' "$User" '-g' "$Group" 'sh'
    Created=$?
    processCommandCode $Created "The ${DESCRIPTION_DATABASE_RESPONSE} was not created: ${Response}"
    Retcode=$?
  fi

  # Restrict the file permissions of the response file.

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' 'chmod' ${RESPONSE_FILE_PERMISSIONS} "$Response"
    processCommandCode $? "Failed to restrict the file permissions to ${RESPONSE_FILE_PERMISSIONS} on the ${DESCRIPTION_DATABASE_RESPONSE}: ${Response}"
    Retcode=$?
  fi

  # Validate that the response file is accessible by the installation user.

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-r' "$Response"
    processCommandCode $? "The ${DESCRIPTION_DATABASE_RESPONSE} is inaccessible: ${Response}"
    Retcode=$?
  fi

  ##
  ## Copy the Oracle Database software.
  ##

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoSection "Copying of the ${DESCRIPTION_PRODUCT_DATABASE} software"
  fi

  # Change the current working directory to the Oracle Database software repository.

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    if [[ ! -d "$Repository" ]] || [[ ! -r "$Repository" ]] ; then
      echoError $RETCODE_OPERATION_ERROR "The ${DESCRIPTION_DATABASE_REPOSITORY} is inaccessible: ${Repository}"
    else
      echoCommand 'cd' "$Repository"
      cd "$Repository"
      processCommandCode $? "Failed to change the current working directory to: ${Repository}"
    fi
    Retcode=$?
  fi

  # Validate that the Oracle Database home directory can be written.

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-d' "$Home"
    processCommandCode $? "The ${DESCRIPTION_DATABASE_HOME} is inaccessible: ${Home}"
    Retcode=$?
  fi

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-w' "$Home"
    processCommandCode $? "The ${DESCRIPTION_DATABASE_HOME} is not writable: ${Home}"
    Retcode=$?
  fi

  # Copy the Oracle Database software.

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$Marker1"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "The ${DESCRIPTION_PRODUCT_DATABASE} software is already copied: ${Home}"
      Retcode=$?
    else
      echoCommandMessage "The ${DESCRIPTION_PRODUCT_DATABASE} software is not already copied: ${Home}"
      echoCommand 'tar' 'cf' '-' '.' '|' "(cd ${Home} ; sudo -u ${User} '-g' "$Group" tar xf -)"
      tar cf - . | (cd "$Home" ; sudo -u "$User" '-g' "$Group" tar xf -)
      processCommandCode $? "Failed to copy the ${DESCRIPTION_PRODUCT_DATABASE} files using the user '${User}:${Group}' from '${Repository}' to '${Home}'"
      Retcode=$?
      # Create indicator that the software has been copied.
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'touch' "$Marker1"
        processCommandCode $? "Failed to create installation marker file: ${Marker1}"
        Retcode=$?
      fi
    fi
  fi

  ##
  ## Modification to allow installing on Oracle Linux 8.
  ##

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoSection 'Modification to allow installing on Oracle Linux 8'
  fi

  # Hack the installation to remove the built-in maximum OS version requirement in order to allow newer versions of Oracle Linux.

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
## TODO: Check version (example OL 7)
    local -r HACK='CV_ASSUME_DISTID=OEL8'
    executeCommand 'sudo' 'test' '-r' "$Requirements"
    processCommandCode $? "The file ${Requirements} was not found"
    Retcode=$?
    if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
      echoCommand 'sudo' 'grep' "$HACK" "$Requirements"
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        echoCommandMessage "Software not hacked for OL8"
        local Output=''
        echoCommand 'echo' "${HACK}.1" '|' 'sudo' "tee -a ${Requirements}"
        Output=`echo "${HACK}.1" | sudo tee -a "$Requirements"`
        processCommandCode $? "Failed to modify file: ${Requirements}"
      else
        echoCommandMessage "Software already hacked for OL8"
      fi
      Retcode=$?
    fi
  fi

  ##
  ## Installation of the Oracle Database.
  ##

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoSection "Installation of the ${DESCRIPTION_PRODUCT_DATABASE}"
  fi

  # Change the current working directory to the Oracle Database Home directory.

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    if [[ ! -d "$Home" ]] || [[ ! -x "$Home" ]] ; then
      echoError $RETCODE_OPERATION_ERROR "${DESCRIPTION_DATABASE_HOME} is inaccessible: ${Home}"
    else
      echoCommand 'cd' "$Home"
      cd "$Home"
      processCommandCode $? "Failed to change the current working directory to: ${Home}"
    fi
    Retcode=$?
  fi

  # Export the ORACLE_HOME environment variable.

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoCommand 'export' "ORACLE_HOME=${Home}"
    export ORACLE_HOME="$Home"
    processCommandCode $? "Failed to export the ${DESCRIPTION_PRODUCT_DATABASE} environment variable ORACLE_HOME: ${Home}"
    Retcode=$?
  fi

  # Install the Oracle Database.

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$Marker2"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "${DESCRIPTION_PRODUCT_DATABASE} is already installed"
      Retcode=$?
    else
      echoCommandMessage "${DESCRIPTION_PRODUCT_DATABASE} is not already installed"
      executeCommand 'sudo' '-E' '-u' "$User" '-g' "$Group" './runInstaller' '-silent' '-responseFile' "$Response"
      processCommandCode $? "Error occurred when running ${DESCRIPTION_PRODUCT_DATABASE} installer program (runInstaller)"
      Retcode=$?
      # Create indicator that the software has been installed.
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'touch' "$Marker2"
        processCommandCode $? "Failed to create installation marker file: ${Marker2}"
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

  # Run the Oracle inventory root installer program, if it exists, using the installation user.

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$Marker3"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "The Oracle Inventory root installer has already been run"
      Retcode=$?
    else
      echoCommandMessage "The Oracle Inventory root installer has not already been run"
      executeCommand 'sudo' '-E' '-u' "$User" '-g' "$Group" 'sudo' 'test' '-x' "$InventoryInstaller"
      if [[ 0 -eq $? ]] ; then
        echoCommandSuccess
        executeCommand 'sudo' '-E' '-u' "$User" '-g' "$Group" 'sudo' "$InventoryInstaller"
        processCommandCode $? "The Oracle Inventory root installer program produced an error: ${InventoryInstaller}"
        Retcode=$?
        # Create indicator that the Oracle Inventory root installer has been run.
        if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
          executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'touch' "$Marker3"
          processCommandCode $? "Failed to create installation marker file: ${Marker3}"
          Retcode=$?
        fi
      else
        echoCommandMessage "The Oracle Inventory root installer program was not found or is innaccessible: ${InventoryInstaller}"
        echoInfo "Skipping running the Oracle Inventory root installer program: ${InventoryInstaller}"
        Retcode=$?
      fi
    fi
  fi

  # Run the Oracle Database root installer program using the installation user.

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$Marker4"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "The ${DESCRIPTION_PRODUCT_DATABASE} root installer has already been run"
      Retcode=$?
    else
      echoCommandMessage "The ${DESCRIPTION_PRODUCT_DATABASE} root installer has not already been run"
      executeCommand 'sudo' '-E' '-u' "$User" '-g' "$Group" 'sudo' 'test' '-x' "$DatabaseInstaller"
      processCommandCode $? "The ${DESCRIPTION_PRODUCT_DATABASE} root installer program was not found or is innaccessible: ${DatabaseInstaller}"
      Retcode=$?
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'sudo' '-E' '-u' "$User" '-g' "$Group" 'sudo' '-E' "$DatabaseInstaller"
        processCommandCode $? "The ${DESCRIPTION_PRODUCT_DATABASE} root installer program produced an error: ${DatabaseInstaller}"
        Retcode=$?
        # Create indicator that the Oracle Database root installer has been run.
        if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
          executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'touch' "$Marker4"
          processCommandCode $? "Failed to create installation marker file: ${Marker4}"
          Retcode=$?
        fi
      fi
    fi
  fi

  # Configure the Oracle Database network settings using the installation user.

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$Marker5"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "The network information of the ${DESCRIPTION_PRODUCT_DATABASE} is already configured"
      Retcode=$?
    else
      echoCommandMessage "The network information of the ${DESCRIPTION_PRODUCT_DATABASE} is not configured"
      executeCommand 'sudo' '-E' '-u' "$User" './runInstaller' '-executeConfigTools' '-silent' '-responseFile' "$Response"
      processCommandCode $? "Error occurred when running ${DESCRIPTION_PRODUCT_DATABASE} installer (runInstaller -executeConfigTools)"
      Retcode=$?
      # Create indicator that the network information of the Oracle Database has been configured.
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'touch' "$Marker5"
        processCommandCode $? "Failed to create installation marker file: ${Marker5}"
        Retcode=$?
      fi
    fi
  fi

  # Delete the Oracle Database automated installation response file.

  if [[ 0 -eq $Created ]] ; then
    executeCommand sudo '-u' "$User" '-g' "$Group" 'test' '-f' "$Response"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "The ${DESCRIPTION_DATABASE_RESPONSE} will be deleted: ${Response}"
      executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'rm' "$Response"
      processCommandCode $? "Failed to the delete the ${DESCRIPTION_DATABASE_RESPONSE}: ${Response}"
    else
      echoCommandMessage "The ${DESCRIPTION_DATABASE_RESPONSE} was not found: ${Response}"
    fi
  fi

  # Modify the oratab file to enable the automatic start and shutdown of the database with dbstart and sbshut.

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$Marker6"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "The automatic start of the ${DESCRIPTION_PRODUCT_DATABASE} is already enabled"
      Retcode=$?
    else
      echoCommandMessage "The automatic start of the ${DESCRIPTION_PRODUCT_DATABASE} is not enabled"
      executeCommand 'sudo' 'test' '-f' "$ORATAB_FILE_NAME"
      if [[ 0 -eq $? ]] ; then
        echoCommandMessage "File found: ${ORATAB_FILE_NAME}"
        executeCommand 'sudo' 'sed' '-i' 's/:N$/:Y/' "$ORATAB_FILE_NAME"
        processCommandCode $? "Failed to modify ${ORATAB_FILE_NAME}"
        Retcode=$?
        # Create indicator that the automatic start of the Oracle Database has been enabled.
        if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
          executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'touch' "$Marker6"
          processCommandCode $? "Failed to create installation marker file: ${Marker6}"
          Retcode=$?
        fi
      else
        echoCommandMessage "File not found: ${ORATAB_FILE_NAME}"
        Retcode=$?
      fi
    fi
  fi

  ##
  ## Configuration of the Oracle Database.
  ##

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoSection "Configuration of the ${DESCRIPTION_PRODUCT_DATABASE}"
  fi

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$Marker7"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "The ${DESCRIPTION_PRODUCT_DATABASE} is already configured"
      Retcode=$?
    else
      echoCommandMessage "The ${DESCRIPTION_PRODUCT_DATABASE} is not configured"

      # Configure the Oracle Database parameters required by Oracle Enterprise Manager.

      executeCommand 'sudo' '-E' '-u' "$User" '-g' "$Group" "${Home}/bin/sqlplus" '/nolog' <<EOF
CONNECT sys/${Password}@${Name} AS sysdba
ALTER SYSTEM SET "_allow_insert_with_update_check"=true scope=both;
ALTER SYSTEM SET session_cached_cursors=200 scope=spfile;
ALTER SYSTEM SET shared_pool_size=600M scope=spfile;
ALTER SYSTEM SET processes=600 scope=spfile;
SHUTDOWN TRANSACTIONAL
EOF
      processCommandCode $? "Failed to configure ${DESCRIPTION_PRODUCT_DATABASE} parameters"
      Retcode=$?

      # Bounce the Oracle Database.

      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'sudo' '-E' '-u' "$User" '-g' "$Group" "${Home}/bin/dbshut" "$Home"
        processCommandCode $? "Failed to stop the ${DESCRIPTION_PRODUCT_DATABASE} listener"
        Retcode=$?
      fi

      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'sudo' '-E' '-u' "$User" '-g' "$Group" "${Home}/bin/dbstart" "$Home"
        processCommandCode $? "Failed to restart the ${DESCRIPTION_PRODUCT_DATABASE} listener"
        Retcode=$?
      fi

      # Create indicator that the Oracle Database has been configured.

      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'touch' "$Marker7"
        processCommandCode $? "Failed to create installation marker file: ${Marker7}"
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
## @param[in] Stage             A staging directory to use during the
##                              installation.
## @param[in] Inventory         The inventory directory of the Oracle
##                              installation (ex. /u01/app/oraInventory).
## @param[in] User              The installation user.
## @param[in] Group             The installation group.
## @param[in] Hostname          The hostname of the machine.
## @param[in] DatabaseName      The name of the database.
## @param[in] DatabaseData      The data directory of the Oracle Database.
## @param[in] DatabasePassword  The password for the database "sys" account.
## @param[in] ManagerRepository The source directory where the Oracle Enterprise
##                              Manager download files were unzipped.
## @param[in] ManagerBase       The base directory of the Oracle Enterprise
##                              Manager.
## @param[in] ManagerHome       The home directory of the Oracle Enterprise
##                              Manager.
## @param[in] InstanceHome      The home directory of the Oracle Enterprise
##                              Manager instance.
## @param[in] AgentBase         The base directory of the Oracle Enterprise
##                              Manager agent.
## @param[in] Response          The filename of the response file to generate.
##                              for the installation.  An existing response file
##                              will be overwritten.
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
  local -r Stage="${1-:-}"
  local -r Inventory="${2:-}"
  local -r User="${3-:-}"
  local -r Group="${4:-}"
  local -r Hostname=${5:-}
  local -r DatabaseName="${6:-}"
  local -r DatabaseData="${7:-}"
  local -r DatabasePassword="${8:-${DEFAULT_DATABASE_PASSWORD}}"
  local -r ManagerRepository="${9-:-}"
  local -r ManagerBase="${10:-}"
  local -r ManagerHome="${11-:-}"
  local -r InstanceHome="${12-:-}"
  local -r AgentBase="${13:-}"
  local -r Response="${14-:-}"
  local -r Installer="${ManagerHome}/allroot.sh"
  local -r ManagerData="${ManagerBase}/oradata"
  local -r WeblogicPassword=${DEFAULT_DATABASE_PASSWORD}
  local -r RepositoryPassword=${DEFAULT_DATABASE_PASSWORD}
  local -r AgentPassword=${DEFAULT_DATABASE_PASSWORD}
  local -r CryptoPassword=${DEFAULT_DATABASE_PASSWORD}
  local -r Marker1="${ManagerHome}/INSTALLATION_MARKER_1"
  local -r Marker2="${ManagerHome}/INSTALLATION_MARKER_2"
  local -r Marker3="${ManagerHome}/INSTALLATION_MARKER_3"
  local -i Created=1
  local -i Retcode=$RETCODE_SUCCESS

  echoTitle "Installing the ${DESCRIPTION_PRODUCT_MANAGER}"

  traceParameter $Retcode "$DESCRIPTION_INSTALLATION_INVENTORY" "$Inventory"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_INSTALLATION_STAGE" "$Stage"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_INSTALLATION_USER" "$User"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_INSTALLATION_GROUP" "$Group"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_INSTALLATION_HOSTNAME" "$Hostname"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_DATABASE_NAME" "$DatabaseName"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_DATABASE_DATA" "$DatabaseData"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_MANAGER_REPOSITORY" "$ManagerRepository"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_MANAGER_BASE" "$ManagerBase"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_MANAGER_HOME" "$ManagerHome"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_MANAGER_INSTANCE" "$InstanceHome"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_AGENT_BASE" "$AgentBase"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_MANAGER_RESPONSE" "$Response"
  Retcode=$?

  ##
  ## Generation of the Oracle Enterprise Manager automated installation response file.
  ##

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoSection "Generation of the ${DESCRIPTION_MANAGER_RESPONSE}"
  fi

  # Generate the response file.

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand sudo '-u' "$User" '-g' "$Group" 'test' '-r' "$Response"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "The ${DESCRIPTION_MANAGER_RESPONSE} already exists and will be overwritten: ${Response}"
    else
      echoCommandMessage "The ${DESCRIPTION_MANAGER_RESPONSE} was not found: ${Response}"
    fi
    echoCommand 'sudo' '-u' "$User" '-g' "$Group" "cat > ${Response} <<EOF ... EOF"
    echo "cat > ${Response} <<EOF
RESPONSEFILE_VERSION=2.2.1.0.0
UNIX_GROUP_NAME=${Group}
# Installation
INSTALL_UPDATES_SELECTION=skip
b_upgrade=false
EM_INSTALL_TYPE=NOSEED
CONFIGURATION_TYPE=ADVANCED
EMPREREQ_AUTO_CORRECTION=yes
CONFIGURE_ORACLE_SOFTWARE_LIBRARY=false
INVENTORY_LOCATION=${Inventory}
# Weblogic
ORACLE_MIDDLEWARE_HOME_LOCATION=${ManagerHome}
ORACLE_HOSTNAME=${Hostname}
WLS_ADMIN_SERVER_USERNAME=weblogic
WLS_ADMIN_SERVER_PASSWORD=${WeblogicPassword}
WLS_ADMIN_SERVER_CONFIRM_PASSWORD=${WeblogicPassword}
NODE_MANAGER_PASSWORD=${WeblogicPassword}
NODE_MANAGER_CONFIRM_PASSWORD=${WeblogicPassword}
ORACLE_INSTANCE_HOME_LOCATION=${InstanceHome}
# Repository
DATABASE_HOSTNAME=${Hostname}
LISTENER_PORT=${DEFAULT_PORT_DATABASE}
SERVICENAME_OR_SID=${DatabaseName}
SYS_PASSWORD=${DatabasePassword}
DEPLOYMENT_SIZE=SMALL
SYSMAN_PASSWORD=${RepositoryPassword}
SYSMAN_CONFIRM_PASSWORD=${RepositoryPassword}
MANAGEMENT_TABLESPACE_LOCATION=${DatabaseData}/mgmt.dbf
CONFIGURATION_DATA_TABLESPACE_LOCATION=${DatabaseData}/mgmt_ecm_depot1.dbf
JVM_DIAGNOSTICS_TABLESPACE_LOCATION=${DatabaseData}/mgmt_deepdive.dbf
# Agent
AGENT_BASE_DIR=${AgentBase}
AGENT_REGISTRATION_PASSWORD=${AgentPassword}
AGENT_REGISTRATION_CONFIRM_PASSWORD=${AgentPassword}
# TLS
Is_oneWaySSL=false
Is_twoWaySSL=true
TRUSTSTORE_PASSWORD=${CryptoPassword}
TRUSTSTORE_LOCATION=${ManagerData}/ewallet-truststore.p12
KEYSTORE_PASSWORD=${CryptoPassword}
KEYSTORE_LOCATION=${ManagerData}/ewallet-keystore.p12
EOF" | sudo '-u' "$User" '-g' "$Group" 'sh'
    Created=$?
    processCommandCode $Created "The ${DESCRIPTION_MANAGER_RESPONSE} was not created: ${Response}"
    Retcode=$?
  fi

  # Restrict the file permissions of the response file.

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' 'chmod' ${RESPONSE_FILE_PERMISSIONS} "$Response"
    processCommandCode $? "Failed to restrict the file permissions to ${RESPONSE_FILE_PERMISSIONS} on the ${DESCRIPTION_MANAGER_RESPONSE}: ${Response}"
    Retcode=$?
  fi

  # Validate that the response file is accessible by the installation user.

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-r' "$Response"
    processCommandCode $? "The ${DESCRIPTION_MANAGER_RESPONSE} is inaccessible: ${Response}"
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
      echoError $RETCODE_OPERATION_ERROR "${DESCRIPTION_MANAGER_REPOSITORY} is inaccessible: ${ManagerRepository}"
    else
      echoCommand 'cd' "$ManagerRepository"
      cd "$ManagerRepository"
      processCommandCode $? "Failed to change the current working directory to: ${ManagerRepository}"
    fi
    Retcode=$?
  fi

  # Export the ORACLE_HOME environment variable.

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoCommand 'export' "ORACLE_HOME=${ManagerHome}"
    export ORACLE_HOME="$ManagerHome"
    processCommandCode $? "Failed to export the environment variable ORACLE_HOME: ${ManagerHome}"
    Retcode=$?
  fi

  # Export the OMS_INSTANCE_HOME environment variable.

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoCommand 'export' "OMS_INSTANCE_HOME=${ManagerInstance}"
    export OMS_INSTANCE_HOME="$ManagerInstance"
    processCommandCode $? "Failed to export the environment variable OMS_INSTANCE_HOME: ${ManagerInstance}"
    Retcode=$?
  fi

  # Run the Oracle Enterprise Manager installer program using the installation user.

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$Marker1"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "The ${DESCRIPTION_PRODUCT_MANAGER} software is already installed: ${ManagerHome}"
      Retcode=$?
    else
      echoCommandMessage "The ${DESCRIPTION_PRODUCT_MANAGER} software is not already installed: ${ManagerHome}"
      executeCommand sudo '-E' '-u' "$User" '-g' "$Group" './em13500_linux64.bin' '-silent' '-responseFile' "$Response" "-J-Djava.io.tmpdir=${Stage}"
      processCommandCode $? "Failed to install Oracle Enterprise Manager: ${ManagerRepository}/em13500_linux64.bin"
      Retcode=$?
      # Create indicator that the Oracle Enterprise Manager has been installed.
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'touch' "$Marker1"
        processCommandCode $? "Failed to create installation marker file: ${Marker1}"
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

  if [[ 0 -eq $Created ]] ; then
    executeCommand sudo '-u' "$User" '-g' "$Group" 'test' '-f' "$Response"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "The ${DESCRIPTION_MANAGER_RESPONSE} will be deleted: ${Response}"
      executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'rm' "$Response"
      processCommandCode $? "Failed to the delete the ${DESCRIPTION_MANAGER_RESPONSE}: ${Response}"
    else
      echoCommandMessage "The ${DESCRIPTION_MANAGER_RESPONSE} was not found: ${Response}"
    fi
  fi

  # Run the Oracle Enterprise Manager root installer program using the root user.

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-f' "$Marker2"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "The ${DESCRIPTION_PRODUCT_MANAGER} root installer has already been run"
      Retcode=$?
    else
      echoCommandMessage "The ${DESCRIPTION_PRODUCT_MANAGER} root installer has not already been run"
      executeCommand 'sudo' '-E' '-u' "$User" '-g' "$Group" 'sudo' 'test' '-x' "$Installer"
      processCommandCode $? "The ${DESCRIPTION_PRODUCT_MANAGER} root installer program was not found or is innaccessible: ${Installer}"
      Retcode=$?
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'sudo' '-E' '-u' "$User" '-g' "$Group" 'sudo' '-E' "$Installer"
        processCommandCode $? "The ${DESCRIPTION_PRODUCT_MANAGER} root installer program produced an error: ${Installer}"
        Retcode=$?
        # Create indicator that the Oracle Enterprise Manager root installer has been run.
        if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
          executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'touch' "$Marker2"
          processCommandCode $? "Failed to create installation marker file: ${Marker2}"
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
        executeCommand 'sudo' 'firewall-cmd' '--permanent' '--zone=public' "--add-port=${DEFAULT_PORT_WEBLOGIC}/tcp"
        processCommandCode $? "Failed to allow public access to the network port of the Weblogic administrative console: ${DEFAULT_PORT_WEBLOGIC}"
        Retcode=$?
        if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
          executeCommand 'sudo' 'firewall-cmd' '--permanent' '--zone=public' "--add-port=${DEFAULT_PORT_MANAGER}/tcp"
          processCommandCode $? "Failed to allow public access to the network port of the ${DESCRIPTION_PRODUCT_MANAGER} console: ${DEFAULT_PORT_MANAGER}"
          Retcode=$?
        fi
        if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
          executeCommand 'sudo' 'firewall-cmd' '--reload'
          processCommandCode $? 'Failed to reload firewalld'
          Retcode=$?
          # Create indicator that Firewalld has been configured for the Oracle Enterprise Manager.
          if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
            executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'touch' "$Marker3"
            processCommandCode $? "Failed to create installation marker file: ${Marker3}"
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
## @param[in] Inventory    The inventory directory of the Oracle installation
##                         (ex. /u01/app/oraInventory).
## @param[in] Base         The base directory of the Oracle installation
##                         (ex. /u01/app/oracle).
## @param[in] User         The installation user.
## @param[in] Group        The installation group.
## @param[in] DatabaseBase The base directory of the Oracle Database.
##                         (ex. /u01/app/oracle/database).
## @param[in] DatabaseHome The home directory of the Oracle Database.
## @param[in] ManagerHome  The home directory of the Oracle Enterprise Manager.
## @param[in] InstanceHome The home directory of the Oracle Enterprise Manager
##                         instance.
## @param[in] AgentBase    The base directory of the Oracle Enterprise Manager
##                         agent.
##
## @note This function performs the following steps:
##
## @li Creation of the installation operating system group and user.
## @li Addition of the installation user to the list of the system sudoers.
## @li Installation of the system libraries.
## @li Adjustment of the system memory cache.
## @li Creation of the Oracle products installation directories. 
## @li Creation of the Systemd service for the Oracle Database.
##
## @return The return code of the function execution.
################################################################################
prepareInstallation() {
  local -r FSTAB='/etc/fstab'
  local -r Inventory="${1:-}"
  local -r Base="${2:-}"
  local -r User="${3:-}"
  local -r Group="${4:-}"
  local -r DatabaseBase="${5:-}"
  local -r DatabaseHome="${6:-}"
  local -r ManagerHome="${7:-}"
  local -r InstanceHome="${8:-}"
  local -r AgentBase="${9:-}"
  local -i Retcode=$RETCODE_SUCCESS

  echoTitle 'Preparing for installation of the Oracle products'

  traceParameter $Retcode "$DESCRIPTION_INSTALLATION_INVENTORY" "$Inventory"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_INSTALLATION_BASE" "$Base"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_INSTALLATION_USER" "$User"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_INSTALLATION_GROUP" "$Group"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_DATABASE_BASE" "$DatabaseBase"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_DATABASE_HOME" "$DatabaseHome"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_MANAGER_HOME" "$ManagerHome"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_MANAGER_INSTANCE" "$InstanceHome"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_AGENT_BASE" "$AgentBase"
  Retcode=$?

  ##
  ## Creation of the operating system user and group.
  ##

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoSection "Creation of the operating system user and group: ${User}:${Group}"
  fi

  # Create the installation group.

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'getent' 'group' "$Group"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "${DESCRIPTION_INSTALLATION_GROUP} already exists: ${Group}"
    else
      executeCommand 'sudo' '/usr/sbin/groupadd' "$Group"
      processCommandCode $? "Failed to create ${DESCRIPTION_INSTALLATION_GROUP}: ${Group}"
    fi
    Retcode=$?
  fi

  # Create the installation user.

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    local Output1=''
    local Output2=''
    echoCommand 'id' "$User"
    Output1=`id "$User"`
    Retcode=$?
    echoCommandMessage "returned ${Retcode}"
    if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
      echoInfo "${DESCRIPTION_INSTALLATION_USER} already exists: ${User}"
      echoCommand 'echo' "$Output1" '|' 'awk' "-F ' ' '{ print \$2 }'" '|' 'awk' "-F '(' '{ print \$2 }'" '|' 'tr' "-d' ')'"
      Output2=`echo "$Output1" | awk -F ' ' '{ print $2 }' | awk -F '(' '{ print $2 }' | tr -d ')'`
      processCommandCode $? "Failed to validate group membership of ${DESCRIPTION_INSTALLATION_USER}: ${User}"
      Retcode=$?
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        if [[ "$Group" == "$Output2" ]] ; then
          echoInfo "Group of ${DESCRIPTION_INSTALLATION_USER} is the ${DESCRIPTION_INSTALLATION_GROUP} (${User}:${Group})"
        else
          echoError $RETCODE_OPERATION_ERROR "Group of ${DESCRIPTION_INSTALLATION_USER} is not ${DESCRIPTION_INSTALLATION_GROUP} (${User}:${Group})"
        fi
        Retcode=$?
      fi
    else
      executeCommand 'sudo' '/usr/sbin/useradd' '-g' "$Group" '–s' '/usr/sbin/nologin' "$User"
      processCommandCode $? "Failed to create ${DESCRIPTION_INSTALLATION_USER}: ${User}:${Group}"
      Retcode=$?
    fi
  fi

  # Retrieve the home directory of the installation user.

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    local -r UserHome="$(getent 'passwd' ${User} | cut '-d:' '-f6')"
    if [[ -z "$UserHome" ]] ; then
      echoError $RETCODE_PARAMETER_ERROR "Failed to determine the home directory of the ${DESCRIPTION_INSTALLATION_USER}: ${User}"
      Retcode=$?
    else
      executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-d' "$UserHome"
      processCommandCode $? "Failed to access the home directory of the ${DESCRIPTION_INSTALLATION_USER} (${User}): ${UserHome}"
      Retcode=$?
    fi
  fi

  # Add the installation user to the operating systems's list of sudoers.

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' 'test' '-r' "$SUDOERS_FILE_NAME"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "${DESCRIPTION_SUDOERS_FILE} already exists: ${SUDOERS_FILE_NAME}"
      Retcode=$?
    else
      echoCommandMessage "${DESCRIPTION_SUDOERS_FILE} not found: ${SUDOERS_FILE_NAME}"
      echoCommand 'sudo' "cat > ${SUDOERS_FILE_NAME} <<EOF ... EOF"
      echo "cat > ${SUDOERS_FILE_NAME} <<EOF
# Created by ${PROGRAM} on $(date)
# Grant sudo privileges to the Oracle installation user
${User} ALL=(ALL) NOPASSWD:ALL
EOF" | sudo 'sh'
      processCommandCode $? "Failed to create ${DESCRIPTION_SUDOERS_FILE}: ${SUDOERS_FILE_NAME}"
      Retcode=$?
      # Restrict the file permissions of the Oracle Database automated installation response file.
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'sudo' 'chmod' "$SUDOERS_FILE_PERMISSIONS" "$SUDOERS_FILE_NAME"
        processCommandCode $? "Failed to restrict the file permissions to ${SUDOERS_FILE_PERMISSIONS} on the ${DESCRIPTION_SUDOERS_FILE}: ${SUDOERS_FILE_NAME}"
        Retcode=$?
      fi
    fi
  fi

  # Validate that the installation user sudoers supplementary file exists.

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' 'test' '-f' "$SUDOERS_FILE_NAME"
    processCommandCode $? "${DESCRIPTION_SUDOERS_FILE} is inaccessible: ${SUDOERS_FILE_NAME}"
    Retcode=$?
  fi

  ##
  ## Installation of the required system libraries.
  ##

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoSection 'Installation of the required system libraries'
  fi

  # Install pre-requisite system libraries.

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' 'yum' '-y' 'install' 'nfs-utils'
    processCommandCode $? "Failed to install pre-requisite system libraries"
    Retcode=$?
  fi

  ##
  ## Adjustment of the system cache to have at least 16GB.
  ##

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoSection 'Adjustment of the system cache for at least 16GB'
  fi

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    local CacheString=''
    echoCommand 'sudo' 'swapon' '--show' '--raw' '--noheadings' '|' 'awk' '-F' "' '" "'BEGIN{ Total = 0 } { if ( \"G\" == substr(\$3,length(\$3),1) ) Total += substr(\$3,1,length(\$3)-1) } END{ print Total }'"
    CacheString=`sudo swapon '--show' '--raw' '--noheadings' | awk '-F' ' ' 'BEGIN{ Total = 0} { if ( "G" == substr($3,length($3),1) ) Total+=substr($3,1,length($3)-1) } END{ print Total }'`
    processCommandCode $? 'Failed to ascertain the system cache size'
    if [[ $RETCODE_SUCCESS -eq $? ]] && [[ -n "$CacheString" ]] && [[ "$CacheString" =~ ^[0-9]+$ ]] ; then
      local -r -i CacheSize=$CacheString
      echoInfo "System cache: ${CacheSize}G"
      echoInfo "System cache objective: ${CACHE_GOAL}G"
    else
      local -r -i CacheSize=0
    fi
    if [[ 0 -ge $CacheSize ]] ; then
      echoInfo "System cache not adjusted: Failed to determine current size: ${CacheSize}"
    elif [[ $CACHE_GOAL -le $CacheSize ]] ; then
      echoInfo 'System cache not adjusted: already large enough'
    else
      local -r -i CacheIncrease=$(($CACHE_GOAL-$CacheSize))
      local -i CacheCreated=$VALUE_FALSE
      local -i CacheAdded=$VALUE_FALSE
      echoInfo "System cache increase: ${CacheIncrease}G"
      executeCommand 'sudo' 'fallocate' '-l' "${CacheIncrease}G" "$CACHE_FILE_NAME"
      CacheCreated=$?
      processCommandCode $CacheCreated "Failed to allocate additional system cache file: ${CACHE_FILE_NAME}"
      Retcode=$?
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'sudo' 'chmod' "$CACHE_FILE_PERMISSIONS" "$CACHE_FILE_NAME"
        processCommandCode $? "Failed to restrict file permissions on additional system cache file: ${CACHE_FILE_NAME}"
        Retcode=$?
      fi
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'sudo' 'mkswap' "$CACHE_FILE_NAME"
        processCommandCode $? "Failed to format new system cache file: ${CACHE_FILE_NAME}"
        Retcode=$?
      fi
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'sudo' 'swapon' "$CACHE_FILE_NAME"
        CacheAdded=$?
        processCommandCode $CacheAdded "Failed to add new file to system cache: ${CACHE_FILE_NAME}"
        Retcode=$?
      fi
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'grep' '-e' "^${CACHE_FILE_NAME}[[:space:]]" "$FSTAB"
        if [[ 0 -eq $? ]] ; then
          echoCommandMessage "${CACHE_FILE_NAME} already found in ${FSTAB}"
        else
          echoCommandSuccess
          echoCommand 'sudo' 'sh' '-c' "echo '-e' '${CACHE_FILE_NAME}\tnone\tswap\tsw\t0\t0' >> '${FSTAB}'"
          sudo 'sh' '-c' "echo -e '${CACHE_FILE_NAME}\tnone\tswap\tsw\t0\t0' >> '${FSTAB}'"
          processCommandCode $? "Failed to add entry to ${FSTAB} for the new system cache file: ${CACHE_FILE_NAME}"
        fi
        Retcode=$?
      fi
      if [[ $RETCODE_SUCCESS -ne $Retcode ]] && [[ $VALUE_TRUE -eq $CacheAdded ]] ; then
        executeCommand 'sudo' 'swapoff' "$CACHE_FILE_NAME"
        processCommandCode $? "Failed to remove new file from system cache: ${CACHE_FILE_NAME}"
      fi
      if [[ $RETCODE_SUCCESS -ne $Retcode ]] && [[ $VALUE_TRUE -eq $CacheCreated ]] ; then
        executeCommand 'sudo' 'rm' "$CACHE_FILE_NAME"
        processCommandCode $? "Failed to delete new system cache file: ${CACHE_FILE_NAME}"
      fi
    fi
  fi

  ##
  ## Creation of the installation directories for the Oracle products.
  ##

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoSection 'Creation of the installation directories for the Oracle products'
  fi

  # Create the installation inventory directory.

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" -g "$Group" 'test' '-d' "$Inventory"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "The ${DESCRIPTION_INSTALLATION_INVENTORY} already exists: ${Inventory}"
      Retcode=$?
    else
      echoCommandMessage "The ${DESCRIPTION_INSTALLATION_INVENTORY} does not exists: ${Inventory}"
      executeCommand 'sudo' 'mkdir' '-m' "$ORACLE_DIRECTORY_PERMISSIONS" '-p' "$Inventory"
      processCommandCode $? "Failed to create the ${DESCRIPTION_INSTALLATION_INVENTORY}: ${Inventory}"
      Retcode=$?
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'sudo' 'chown' "${User}:${Group}" "$Inventory"
        processCommandCode $? "Failed to set ownership (${User}:${Group}) on the ${DESCRIPTION_INSTALLATION_INVENTORY}: ${Inventory}"
        Retcode=$?
      fi
    fi
  fi

  # Create the installation base directory.

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-d' "$Base"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "The ${DESCRIPTION_INSTALLATION_BASE} already exists: ${Base}"
      Retcode=$?
    else
      echoCommandMessage "The ${DESCRIPTION_INSTALLATION_BASE} does not exists: ${Base}"
      executeCommand 'sudo' 'mkdir' '-m' "$ORACLE_DIRECTORY_PERMISSIONS" '-p' "$Base"
      processCommandCode $? "Failed to create the ${DESCRIPTION_INSTALLATION_BASE}: ${Base}"
      Retcode=$?
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'sudo' 'chown' "${User}:${Group}" "$Base"
        processCommandCode $? "Failed to set the ownership to ${User}:${Group} on the ${DESCRIPTION_INSTALLATION_BASE}: ${Base}"
        Retcode=$?
      fi
    fi
  fi

  # Create the Oracle Database home directory.

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-d' "$DatabaseHome"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "The ${DESCRIPTION_DATABASE_HOME} already exists: ${DatabaseHome}"
    else
      echoCommandMessage "The ${DESCRIPTION_DATABASE_HOME} does not exists: ${DatabaseHome}"
      executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'mkdir' '-m' "$ORACLE_DIRECTORY_PERMISSIONS" '-p' "$DatabaseHome"
      processCommandCode $? "Failed to create the ${DESCRIPTION_DATABASE_HOME}: ${DatabaseHome}"
    fi
    Retcode=$?
  fi

  # Create the Oracle Enterprise Manager home directory.

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-d' "$ManagerHome"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "The ${DESCRIPTION_MANAGER_HOME} already exists: ${ManagerHome}"
    else
      echoCommandMessage "The ${DESCRIPTION_MANAGER_HOME} does not exists: ${ManagerHome}"
      executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'mkdir' '-m' "$ORACLE_DIRECTORY_PERMISSIONS" '-p' "$ManagerHome"
      processCommandCode $? "Failed to create the ${DESCRIPTION_MANAGER_HOME}: ${ManagerHome}"
    fi
    Retcode=$?
  fi

  # Create the Oracle Enterprise Manager instance home directory.

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-d' "$InstanceHome"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "The ${DESCRIPTION_MANAGER_INSTANCE} already exists: ${InstanceHome}"
    else
      echoCommandMessage "The ${DESCRIPTION_MANAGER_INSTANCE} does not exists: ${InstanceHome}"
      executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'mkdir' '-m' "$ORACLE_DIRECTORY_PERMISSIONS" '-p' "$InstanceHome"
      processCommandCode $? "Failed to create the ${DESCRIPTION_MANAGER_INSTANCE}: ${InstanceHome}"
    fi
    Retcode=$?
  fi

  # Create the Oracle Enterprise Manager agent base directory.

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-d' "$AgentBase"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "The ${DESCRIPTION_AGENT_BASE} already exists: ${AgentBase}"
    else
      echoCommandMessage "The ${DESCRIPTION_AGENT_BASE} does not exists: ${AgentBase}"
      executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'mkdir' '-m' "$ORACLE_DIRECTORY_PERMISSIONS" '-p' "$AgentBase"
      processCommandCode $? "Failed to create the ${DESCRIPTION_AGENT_BASE}: ${AgentBase}"
    fi
    Retcode=$?
  fi

  ##
  ## Create the Systemd service for the Oracle Database.
  ##

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoSection "Creation of the ${DESCRIPTIOM_SYSTEMD_SERVICE}"
  fi

  # Create the Oracle Database service control program.

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    local -r ControlFile="${UserHome}/${CONTROL_FILE_NAME}"
    executeCommand 'sudo' '-u' "$User" '-g' "$Group" 'test' '-x' "$ControlFile"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "The ${DESCRIPTION_CONTROL_FILE} already exists and will be overwritten: ${ControlFile}"
    else
      echoCommandMessage "The ${DESCRIPTION_CONTROL_FILE} was not found: ${ControlFile}"
    fi
    echoCommand 'sudo' '-u' "$User" '-g' "$Group" "cat > ${ControlFile} <<EOF ... EOF"
    echo '-e' "cat > ${ControlFile} <<EOF
#!/usr/bin/bash

# Created by ${PROGRAM} on $(date)

export TMPDIR='/tmp'
export TMP='/tmp'
export PATH=\"${DatabaseHome}/bin:/usr/local/bin:\\\${PATH}\"
export LD_LIBRARY_PATH='${DatabaseHome}/lib:/lib:/usr/lib'
export CLASSPATH='${DatabaseHome}/jlib:${DatabaseHome}/rdbms/jlib'

controlManager() {
  local Log=''
  local -i Retcode=0
  if [[ 0 -eq \\\$Retcode ]] ; then
    export ORACLE_HOME='$ManagerHome'
    if [[ -n \"\\\$ORACLE_HOME\" ]] && [[ -x \"\\\${ORACLE_HOME}/bin/emctl\" ]] ; then
      cd \"\\\$ORACLE_HOME\"
      Log=\\\$(bin/emctl \\\$1 oms)
      Retcode=\\\$?
    fi
  fi
  if [[ 0 -eq \\\$Retcode ]] && [[ -r '${AgentBase}/agentInstall.rsp' ]] ; then
    export ORACLE_HOME=\\\$(grep 'ORACLE_HOME' '${AgentBase}/agentInstall.rsp' | awk -F '=' '{print \\\$2}')
    if [[ -n \"\\\$ORACLE_HOME\" ]] && [[ -x \"\\\${ORACLE_HOME}/bin/emctl\" ]] ; then
      cd \"\\\$ORACLE_HOME\"
      Log=\\\$(bin/emctl \\\$1 agent)
      Retcode=\\\$?
    fi
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
  if [[ 0 -eq \\\$Retcode ]] && [[ -x '${DatabaseHome}/bin/dbstart' ]] ; then
    Log=\\\$(\"${DatabaseHome}/bin/dbstart\" '$DatabaseHome')
    Retcode=\\\$?
  fi
  if [[ 0 -eq \\\$Retcode ]] ; then
    Log=\\\$(controlManager 'start')
    Retcode=\\\$?
  fi
elif [[ 'stop' = \"\\\$1\" ]] ; then
  if [[ 0 -eq \\\$Retcode ]] ; then
    Log=\\\$(controlManager 'stop')
    Retcode=\\\$?
  fi
  if [[ 0 -eq \\\$Retcode ]] &&[[ -x '${DatabaseHome}/bin/dbshut' ]] ; then
    Log=\\\$(\"${DatabaseHome}/bin/dbshut\" '$DatabaseHome')
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
    processCommandCode $? "Failed to create the ${DESCRIPTION_CONTROL_FILE}: ${ControlFile}"
    Retcode=$?
    if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
      executeCommand 'sudo' 'chmod' "$CONTROL_FILE_PERMISSIONS" "$ControlFile"
      processCommandCode $? "Failed to restrict the file permissions to ${CONTROL_FILE_PERMISSIONS} on the ${DESCRIPTION_CONTROL_FILE}: ${ControlFile}"
      Retcode=$?
    fi
  fi

  # Create the Systemd service file for Oracle Database.

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' 'root' '-g' 'root' 'test' '-f' "$SYSTEMD_FILE_NAME"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "The ${DESCRIPTIOM_SYSTEMD_FILE} already exists and will be overwritten: ${SYSTEMD_FILE_NAME}"
    else
      echoCommandMessage "The ${DESCRIPTIOM_SYSTEMD_FILE} was not found: ${SYSTEMD_FILE_NAME}"
    fi
    echoCommand 'sudo' '-u' 'root' '-g' 'root' "cat > ${SYSTEMD_FILE_NAME} <<EOF ... EOF"
    echo "cat > ${SYSTEMD_FILE_NAME} <<EOF
# Created by ${PROGRAM} on $(date)

[Unit]
Description=The ${DESCRIPTION_PRODUCT_DATABASE} Service
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
    processCommandCode $? "Failed to create the ${DESCRIPTIOM_SYSTEMD_FILE}: ${SYSTEMD_FILE_NAME}"
    Retcode=$?
    if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
      executeCommand 'sudo' 'chmod' "$SYSTEMD_FILE_PERMISSIONS" "$SYSTEMD_FILE_NAME"
      processCommandCode $? "Failed to restrict the file permissions to ${SYSTEMD_FILE_PERMISSIONS} on the ${DESCRIPTIOM_SYSTEMD_FILE}: ${SYSTEMD_FILE_NAME}"
      Retcode=$?
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand 'sudo' 'systemctl' 'enable' "$SYSTEMD_NAME"
        processCommandCode $? "Failed to enable the ${DESCRIPTIOM_SYSTEMD_SERVICE}: ${SYSTEMD_NAME}"
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
## @param[in] User  The installation user.
## @param[in] Group The installation group.
## @param[in] Home  The home directory of the Oracle Database.
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
  local -r User="${1-:-}"
  local -r Group="${2-:-}"
  local -r Home="${3:-}"
  local -r Deinstaller="${Home}/deinstall/deinstall"
  local Response=''
  local -i Retcode=$RETCODE_SUCCESS

  echoTitle "Uninstalling the ${DESCRIPTION_PRODUCT_DATABASE}"

  traceParameter $Retcode "$DESCRIPTION_INSTALLATION_USER" "$User"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_INSTALLATION_GROUP" "$Group"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_DATABASE_HOME" "$Home"
  Retcode=$?

  # Validate that the Oracle Database is installed in the provided home directory. #

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' 'test' '-d' "$Home"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "${DESCRIPTION_PRODUCT_DATABASE} home directory found: ${Home}"
      Retcode=$?
    else
      echoCommandMessage "${DESCRIPTION_PRODUCT_DATABASE} home directory not found: ${Home}"
      return $RETCODE_SUCCESS
    fi
  fi

  # Validate that the Oracle Database de-installer is present and usable by the installation user. #

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" -g "$Group" 'test' '-x' "$Deinstaller"
    processCommandCode $? "${DESCRIPTION_PRODUCT_DATABASE} de-installer program is inaccessible: ${Deinstaller}"
    Retcode=$?
  fi

  # Generate the automated uninstallation response file. #

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    local Line=''
    local Left=''
    local Right=''
    while IFS= read -r Line ; do
      Left=`echo "$Line" | awk -F ':' '{ print $1 }'`
      if [[ 'Location of response file generated' == "$Left" ]] ; then
        Right=`echo "$Line" | awk -F ':' '{ print $2 }'`
      fi
    done < <(sudo -u "$User" -g "$Group" "$Deinstaller" -silent -checkonly)
    if [[ -n "$Right" ]] ; then
      Response=$(echo "$Right" | awk -F \' '{ print $2 }')
    fi
    if [[ -z "$Response" ]] ; then
      echoError $RETCODE_OPERATION_ERROR "Failed to obtain a response file from the ${DESCRIPTION_PRODUCT_DATABASE} de-installer program: ${Deinstaller}"
    else
      echoInfo "Response file: ${Response}"
    fi
    Retcode=$?
  fi

  # Validate that the automated uninstallation response file is present and accessible to the installation user. #

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" -g "$Group" 'test' '-r' "$Response"
    processCommandCode $? "${DESCRIPTION_DATABASE_RESPONSE} is inaccessible: ${Response}"
    Retcode=$?
  fi

  # Uninstall the Oracle Database software. #

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-u' "$User" -g "$Group" "$Deinstaller" '-silent' '-paramfile' "$Response"
    processCommandCode $? "The ${DESCRIPTION_PRODUCT_DATABASE} de-installer program encountered an error (response file = ${Response})"
    Retcode=$?
  fi

  return $Retcode
}

################################################################################
## @fn uninstallManager
##
## @brief Uninstall the Oracle Enterprise Manager.
##
## @param[in] Stage A staging directory to use during the installation.
## @param[in] User  The installation user.
## @param[in] Group The installation group.
## @param[in] Home  The home directory of the Oracle Enterprise Manager.
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
  local -r DatabasePassword='Abcd_1234'
  local -r SysmanPassword='Abcd_1234'
  local -r AdminPassword='Abcd_1234'
  local -r Stage="${1-:-}"
  local -r User="${2-:-}"
  local -r Group="${3-:-}"
  local -r Home="${4:-}"
  local -r Deinstaller1="${Home}/sysman/install/EMDeinstall.pl"
  local -r Deinstaller2="${Stage}/EMDeinstall.pl"
  local -i Retcode=$RETCODE_SUCCESS

  echoTitle "Uninstalling the ${DESCRIPTION_PRODUCT_MANAGER}"

  traceParameter $Retcode "$DESCRIPTION_INSTALLATION_STAGE" "$Stage"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_INSTALLATION_USER" "$User"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_INSTALLATION_GROUP" "$Group"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_MANAGER_HOME" "$Home"
  Retcode=$?

  # Validate that the Oracle Enterprise Manager is installed in the provided home directory. #

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand sudo 'test' '-d' "$Home"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "${DESCRIPTION_PRODUCT_MANAGER} home directory found: ${Home}"
      Retcode=$?
    else
      echoCommandMessage "${DESCRIPTION_PRODUCT_MANAGER} home directory not found: ${Home}"
      return $RETCODE_SUCCESS
    fi
  fi

  # Validate that the Oracle Enterprise Manager de-installer program is present. #

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand sudo '-u' "$User" '-g' "$Group" 'test' '-r' "$Deinstaller1"
    if [[ 0 -eq $? ]] ; then
      echoCommandMessage "${DESCRIPTION_PRODUCT_MANAGER} de-installer program found: ${Deinstaller1}"
      Retcode=$?
    else
      echoCommandMessage "${DESCRIPTION_PRODUCT_MANAGER} de-installer program not found: ${Deinstaller1}"
      return $RETCODE_SUCCESS
    fi
  fi

  # Stage the Oracle Enterprise Manager de-installer program to the staging location. #

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand sudo '-u' "${User}" '-g' "$Group" 'cp' "$Deinstaller1" "$Deinstaller2"
    processCommandCode $? "The ${DESCRIPTION_PRODUCT_MANAGER} de-installer program ${Deinstaller1} was not copied to ${Deinstaller2}"
    Retcode=$?
  fi

  # Uninstall the Oracle Enterprise Manager. #

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    echoCommand 'printf' "y\n${DatabasePassword}\n${SysmanPassword}\n${AdminPassword}\n" '|' 'sudo' 'su' '-' "$User" '-s' '/usr/bin/bash' '-c' "${Home}/perl/bin/perl" "$Deinstaller2" '-mwHome' "$Home" '-stageLoc' "$Stage"
    printf "y\n${DatabasePassword}\n${SysmanPassword}\n${AdminPassword}\n" | sudo 'su' '-' "${User}" '-s' '/usr/bin/bash' '-c' "${Home}/perl/bin/perl ${Deinstaller2} -mwHome ${Home} -stageLoc ${Stage}"
    processCommandCode $? "The ${DESCRIPTION_PRODUCT_MANAGER} de-installer program encountered an error"
    Retcode=$?
  fi

  # Delete the staged Oracle Enterprise Manager de-installer program. #

  executeCommand sudo '-u' "$User" '-g' "$Group" 'test' '-r' "$Deinstaller2"
  if [[ 0 -eq $? ]] ; then
    echoCommandMessage "Staged ${DESCRIPTION_PRODUCT_MANAGER} de-installer program found: ${Deinstaller2}"
  else
    echoCommandMessage "Staged ${DESCRIPTION_PRODUCT_MANAGER} de-installer program not found: ${Deinstaller2}"
  fi
  local -r -i Retcode2=$?

  if [[ $RETCODE_SUCCESS -eq $Retcode2 ]] ; then
    executeCommand sudo '-u' "$User" '-g' "$Group" 'rm'  "$Deinstaller2"
    processCommandCode $? "Failed to delete the temporary ${DESCRIPTION_PRODUCT_MANAGER} de-installer program: ${Deinstaller2}"
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

declare -i Retcode=$RETCODE_SUCCESS

if [[ 1 -gt $# ]] ; then
  echoHelp 0
  exit $?
fi

declare INSTALLATION_REPOSITORY=''
declare INSTALLATION_ROOT=''
declare INSTALLATION_USER=''
declare INSTALLATION_GROUP=''
declare DATABASE_VERSION=''
declare DATABASE_NAME=''
declare MANAGER_VERSION=''

# Read the options.

declare Left=''
declare Option=''
declare OptionValue=''

while [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ -n "$1" ]] && [[ "${1::2}" = '--' ]] ; do
  Left="${1%=*}"
  Option=${Left:2}
  OptionValue="${1#*=}"
  case "$Option" in
    "$OPTION_INSTALLATION_REPOSITORY")
      setOption "$Option" "$OptionValue" 'INSTALLATION_REPOSITORY'
      ;;
    "$OPTION_INSTALLATION_ROOT")
      setOption "$Option" "$OptionValue" 'INSTALLATION_ROOT'
      ;;
    "$OPTION_INSTALLATION_USER")
      setOption "$Option" "$OptionValue" 'INSTALLATION_USER'
      ;;
    "$OPTION_INSTALLATION_GROUP")
      setOption "$Option" "$OptionValue" 'INSTALLATION_GROUP'
      ;;
    "$OPTION_DATABASE_VERSION")
      setOption "$Option" "$OptionValue" 'DATABASE_VERSION'
      ;;
    "$OPTION_DATABASE_NAME")
      setOption "$Option" "$OptionValue" 'DATABASE_NAME'
      ;;
    "$OPTION_MANAGER_VERSION")
      setOption "$Option" "$OptionValue" 'MANAGER_VERSION'
      ;;
    *)
      echoError $RETCODE_PARAMETER_ERROR "Unknown parameter: ${1}"
      ;;
  esac
  Retcode=$?
  shift
done

unset Left
unset Option
unset OptionValue

# Read the command.

if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
  if [[ 1 -eq $# ]] ; then
    if [[ "$COMMAND_HELP" == "$1" ]] ||  [[ "$COMMAND_OPTIONS" == "$1" ]] || [[ "$COMMAND_INSTALL" == "$1" ]] || [[ "$COMMAND_UNINSTALL" == "$1" ]] ; then
      declare -r COMMAND="$1"
    else
      echoError $RETCODE_PARAMETER_ERROR "Unknown command program: ${1}"
      Retcode=$?
    fi
  else
    echoError $RETCODE_PARAMETER_ERROR 'Incorrect command paramaters'
    Retcode=$?
  fi
fi

# Use default values for any option that was not set.

if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
  setOption "$OPTION_INSTALLATION_REPOSITORY" "$DEFAULT_INSTALLATION_REPOSITORY" 'INSTALLATION_REPOSITORY' $Retcode $VALUE_TRUE
  Retcode=$?
  declare -r INSTALLATION_REPOSITORY

  setOption "$OPTION_INSTALLATION_ROOT" "$DEFAULT_INSTALLATION_ROOT" 'INSTALLATION_ROOT' $Retcode $VALUE_TRUE
  Retcode=$?
  declare -r INSTALLATION_ROOT

  setOption "$OPTION_INSTALLATION_USER" "$DEFAULT_INSTALLATION_USER" 'INSTALLATION_USER' $Retcode $VALUE_TRUE
  Retcode=$?
  declare -r INSTALLATION_USER

  setOption "$OPTION_INSTALLATION_GROUP" "$DEFAULT_INSTALLATION_GROUP" 'INSTALLATION_GROUP' $Retcode $VALUE_TRUE
  Retcode=$?
  declare -r INSTALLATION_GROUP

  setOption "$OPTION_DATABASE_VERSION" "$DEFAULT_DATABASE_VERSION" 'DATABASE_VERSION' $Retcode $VALUE_TRUE
  Retcode=$?
  declare -r DATABASE_VERSION

  setOption "$OPTION_DATABASE_NAME" "$DEFAULT_DATABASE_NAME" 'DATABASE_NAME' $Retcode $VALUE_TRUE
  Retcode=$?
  declare -r DATABASE_NAME

  setOption "$OPTION_MANAGER_VERSION" "$DEFAULT_MANAGER_VERSION" 'MANAGER_VERSION' $Retcode $VALUE_TRUE
  Retcode=$?
  declare -r MANAGER_VERSION
fi

# Configure parameters based on program options.

if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
  declare -r INSTALLATION_STAGE="${DEFAULT_INSTALLATION_STAGE}"
  declare -r INSTALLATION_BASE="${INSTALLATION_ROOT}/${INSTALLATION_USER}"
  declare -r INSTALLATION_INVENTORY="${INSTALLATION_ROOT}/oraInventory"
  declare -r INSTALLATION_HOSTNAME="$DEFAULT_INSTALLATION_HOSTNAME"
  declare -r DATABASE_REPOSITORY="${INSTALLATION_REPOSITORY}/${PRODUCT_DATABASE}/${DATABASE_VERSION}"
  declare -r DATABASE_BASE="${INSTALLATION_BASE}/${PRODUCT_DATABASE}"
  declare -r DATABASE_HOME="${DATABASE_BASE}/product/${DATABASE_VERSION}/dbhome_1"
  declare -r DATABASE_DATA="${DATABASE_BASE}/oradata/${DATABASE_NAME}"
  declare -r DATABASE_RECOVERY="${DATABASE_BASE}/recovery/${DATABASE_NAME}"
  declare -r DATABASE_PASSWORD="${DEFAULT_DATABASE_PASSWORD}"
  declare -r DATABASE_RESPONSE="$DEFAULT_DATABASE_RESPONSE"
  declare -r MANAGER_REPOSITORY="${INSTALLATION_REPOSITORY}/${PRODUCT_MANAGER}/${MANAGER_VERSION}"
  declare -r MANAGER_BASE="${INSTALLATION_BASE}/${PRODUCT_MANAGER}"
  declare -r MANAGER_HOME="${MANAGER_BASE}/product/${MANAGER_VERSION}"
  declare -r MANAGER_INSTANCE="${MANAGER_BASE}/gc_inst"
  declare -r MANAGER_RESPONSE="$DEFAULT_MANAGER_RESPONSE"
  declare -r AGENT_BASE="${INSTALLATION_BASE}/${PRODUCT_AGENT}"
fi

if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
  case "$COMMAND" in
    "$COMMAND_HELP")
      echoHelp 1
      Retcode=$?
      ;;
    "$COMMAND_OPTIONS")
      displayOptions
      Retcode=$?
      ;;
    "$COMMAND_INSTALL")
      displayOptions
      Retcode=$?
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        prepareInstallation \
          "$INSTALLATION_INVENTORY" \
          "$INSTALLATION_BASE" \
          "$INSTALLATION_USER" \
          "$INSTALLATION_GROUP" \
          "$DATABASE_BASE" \
          "$DATABASE_HOME" \
          "$MANAGER_HOME" \
          "$MANAGER_INSTANCE" \
          "$AGENT_BASE"
        Retcode=$?
      fi
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        installDatabase \
          "$INSTALLATION_INVENTORY" \
          "$INSTALLATION_USER" \
          "$INSTALLATION_GROUP" \
          "$DATABASE_REPOSITORY" \
          "$DATABASE_BASE" \
          "$DATABASE_HOME" \
          "$DATABASE_NAME" \
          "$DATABASE_DATA" \
          "$DATABASE_RECOVERY" \
          "$DATABASE_PASSWORD" \
          "$DATABASE_RESPONSE"
        Retcode=$?
      fi
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        installManager \
          "$INSTALLATION_STAGE" \
          "$INSTALLATION_INVENTORY" \
          "$INSTALLATION_USER" \
          "$INSTALLATION_GROUP" \
          "$INSTALLATION_HOSTNAME" \
          "$DATABASE_NAME" \
          "$DATABASE_DATA" \
          "$DATABASE_PASSWORD" \
          "$MANAGER_REPOSITORY" \
          "$MANAGER_BASE" \
          "$MANAGER_HOME" \
          "$MANAGER_INSTANCE" \
          "$AGENT_BASE" \
          "$MANAGER_RESPONSE"
        Retcode=$?
      fi
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        echo 'Installation successful'
        echo "ORACLE_BASE=${DATABASE_BASE}"
        echo "ORACLE_HOME=${DATABASE_HOME}"
      else
        echo 'Installation failed'
      fi
      ;;
    "$COMMAND_UNINSTALL")
      displayOptions
      Retcode=$?
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        uninstallManager \
          "$INSTALLATION_STAGE" \
          "$INSTALLATION_USER" \
          "$INSTALLATION_GROUP" \
          "$MANAGER_HOME"
        Retcode=$?
      fi
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        uninstallDatabase \
          "$INSTALLATION_USER" \
          "$INSTALLATION_GROUP" \
          "$DATABASE_HOME"
        Retcode=$?
      fi
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        echo 'Uninstallation successful'
      else
        echo 'Uninstallation failed'
      fi
      ;;
    *)
      echoError $RETCODE_INTERNAL_ERROR "Command not implemented yet or supported: ${COMMAND}"
      Retcode=$?
      ;;
  esac
fi

exit $Retcode
