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
declare OPTION_DATABASE_DOMAIN='domain'
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
declare -r DEFAULT_INSTALLATION_SUDOERS='/etc/sudoers.d/100-oracle-user'
declare -r DEFAULT_DATABASE_VERSION='19.3.0.0.0'
declare -r DEFAULT_DATABASE_NAME='emrep'
declare -r DEFAULT_DATABASE_DOMAIN='oracle.com'
declare -r DEFAULT_DATABASE_PASSWORD='Abcd_1234'
declare -r DEFAULT_DATABASE_RESPONSE='/tmp/db_install.rsp'
declare -r DEFAULT_MANAGER_VERSION='13.5.0.0.0'
declare -r DEFAULT_MANAGER_RESPONSE='/tmp/em_install.rsp'

########################################################
# Program options and function parameters descriptions #
########################################################

declare -r DESCRIPTION_INSTALLATION_REPOSITORY='Oracle software repository directory'
declare -r DESCRIPTION_INSTALLATION_STAGE='Staging installation directory'
declare -r DESCRIPTION_INSTALLATION_ROOT='Oracle installation root directory'
declare -r DESCRIPTION_INSTALLATION_INVENTORY='Oracle inventory directory'
declare -r DESCRIPTION_INSTALLATION_BASE='Oracle installation base directory'
declare -r DESCRIPTION_INSTALLATION_USER='installation user'
declare -r DESCRIPTION_INSTALLATION_GROUP='installation group'
declare -r DESCRIPTION_INSTALLATION_HOSTNAME='installation host name'
declare -r DESCRIPTION_INSTALLATION_SUDOERS="${DESCRIPTION_INSTALLATION_USER} sudoers supplementary file"
declare -r DESCRIPTION_DATABASE_VERSION="${DESCRIPTION_PRODUCT_DATABASE} version"
declare -r DESCRIPTION_DATABASE_REPOSITORY="${DESCRIPTION_PRODUCT_DATABASE} software repository directory"
declare -r DESCRIPTION_DATABASE_BASE="${DESCRIPTION_PRODUCT_DATABASE} base directory"
declare -r DESCRIPTION_DATABASE_HOME="${DESCRIPTION_PRODUCT_DATABASE} home directory"
declare -r DESCRIPTION_DATABASE_NAME="${DESCRIPTION_PRODUCT_DATABASE} name"
declare -r DESCRIPTION_DATABASE_DOMAIN="${DESCRIPTION_PRODUCT_DATABASE} domain"
declare -r DESCRIPTION_DATABASE_DATA="${DESCRIPTION_PRODUCT_DATABASE} data directory"
declare -r DESCRIPTION_DATABASE_RECOVERY="${DESCRIPTION_PRODUCT_DATABASE} recovery directory"
declare -r DESCRIPTION_DATABASE_RESPONSE="automated ${DESCRIPTION_PRODUCT_DATABASE} response file"
declare -r DESCRIPTION_MANAGER_REPOSITORY="${DESCRIPTION_PRODUCT_MANAGER} software repository directory"
declare -r DESCRIPTION_MANAGER_BASE="${DESCRIPTION_PRODUCT_MANAGER} base directory"
declare -r DESCRIPTION_MANAGER_HOME="${DESCRIPTION_PRODUCT_MANAGER} home directory"
declare -r DESCRIPTION_MANAGER_VERSION="${DESCRIPTION_PRODUCT_MANAGER} version"
declare -r DESCRIPTION_MANAGER_RESPONSE="automated ${DESCRIPTION_PRODUCT_MANAGER} response file"
declare -r DESCRIPTION_AGENT_BASE="${DESCRIPTION_PRODUCT_AGENT} base directory"

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

declare -r -i VALUE_FALSE=0
declare -r -i VALUE_TRUE=1
declare -r -i HELP_INDENT_LENGTH=2
declare -r -i HELP_PADDING_LENGTH=24
declare -r -i DESCRIPTION_LENGTH=56

################################ Utility functions ################################

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
  echoHelpOption "$OPTION_DATABASE_DOMAIN" "$DESCRIPTION_DATABASE_DOMAIN" "$DEFAULT_DATABASE_DOMAIN"
  echoHelpOption "$OPTION_MANAGER_VERSION" "$DESCRIPTION_MANAGER_VERSION" "$DEFAULT_MANAGER_VERSION"
  echo
  if [[ 1 -eq $1 ]] ; then
    echo 'Summary:'
    echo "This program is designed for the simplified installation and uninstallation of ${DESCRIPTION_PRODUCT_DATABASE} 19c and ${DESCRIPTION_PRODUCT_MANAGER} 13cc on Oracle Linux 8.  A new database is launched during the install process for immediate use.  The installation is standardized without many options and should not be regarded as being bullet-proof."
    echo
    echo 'Detailed description:'
    echo "The Oracle Database software must be separately procured and unzipped in a directory that is referred by this program as the ${DESCRIPTION_DATABASE_REPOSITORY}.  The program copies the Oracle Database software from the repository to the ${DESCRIPTION_DATABASE_HOME^}, and installs it with the ${DESCRIPTION_INSTALLATION_USER} and the ${DESCRIPTION_INSTALLATION_GROUP}.  If these do not already exist on the system, the program automatically creates them.  The ${DESCRIPTION_INSTALLATION_USER} is also automatically added to the operating system list of Sudoers, if it is not already in this list.  An ${DESCRIPTION_DATABASE_RESPONSE} is generated, unless it already exists, but it is not removed upon termination of the program to allow for diagnosis.  Note that a default database password is hard-coded in cleartext in the response file.  The ${DESCRIPTION_INSTALLATION_BASE^}, as well as the ${DESCRIPTION_INSTALLATION_INVENTORY^}, are determined by the program by using the ${DESCRIPTION_INSTALLATION_ROOT} and following the guidelines of the Oracle Optimal Flexible Architecture."
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
## @fn echoNotice
##
## @brief Echo a command completion notice message.
##
## @param[in] Message The message to echo.
##
## @return RETCODE_SUCCESS
################################################################################
echoNotice() {
  local -r Message="${1:-}"
  if [[ -n "$Message" ]] ; then
    echo "...${Message^}"
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
## @brief Echo a command and its parameters, then execute it.
##
## @param[in] ... The command and its parameters.
##
## @return The exit code of the command.
################################################################################
executeCommand() {
  echo "$@"
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
    echoNotice "Success"
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
## @fn configureDatabase
##
## @brief Configure the Oracle Database after installation.
##
## @param[in] User     The installation user.
## @param[in] Home     The Oracle Database home directory.
## @param[in] Database The name of the database.
## @param[in] Password The password of the database sys account.
##
## @return the return code of the function execution.
################################################################################
configureDatabase() {
  local -r ORATAB='/etc/oratab'
  local -r User="${1:-}"
  local -r Home="${2:-}"
  local -r Database="${3:-}"
  local -r Password="${4:-}"
  local -i Retcode=$RETCODE_SUCCESS

  echoTitle "Configuring the ${DESCRIPTION_PRODUCT_DATABASE} database after its installation"

  traceParameter $Retcode "$DESCRIPTION_INSTALLATION_USER" "$User"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_DATABASE_HOME" "$Home"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_DATABASE_NAME" "$Database"
  Retcode=$?

  export ORACLE_HOME="$Home"

  # Enable the automatic start of the Oracle Database during system boot. #

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand sudo 'sed' '-i' 's/:N$/:Y/' "$ORATAB"
    processCommandCode $? "Failed to modify ${ORATAB}"
    Retcode=$?
  fi

  # Configure the Oracle Database parameters required by Oracle Enterprise Manager. #

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand sudo '-E' '-u' "$User" "${Home}/bin/sqlplus" '/nolog' <<EOF
CONNECT sys/${Password}@${Database} AS sysdba
ALTER SYSTEM SET "_allow_insert_with_update_check"=true scope=both;
ALTER SYSTEM SET session_cached_cursors=200 scope=spfile;
ALTER SYSTEM SET shared_pool_size=600M scope=spfile;
ALTER SYSTEM SET processes=600 scope=spfile;
QUIT;
EOF
    processCommandCode $? "Failed to configure ${DESCRIPTION_PRODUCT_DATABASE} parameters"
    Retcode=$?
  fi

  # Bounce the Oracle Database. #

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand sudo '-E' '-u' "$User" "${Home}/bin/dbshut" "$Home"
    processCommandCode $? "Failed to stop the ${DESCRIPTION_PRODUCT_DATABASE}"
    Retcode=$?
  fi

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand sudo '-E' '-u' "$User" "${Home}/bin/dbstart" "$Home"
    processCommandCode $? "Failed to restart the ${DESCRIPTION_PRODUCT_DATABASE}"
    Retcode=$?
  fi

  return $Retcode
}

################################################################################
## @fn configurePrerequisites
##
## @brief Configure the pre-requisites on the host system needed to install the
##        Oracle products.
##
## @param[in] User    The installation user.
## @param[in] Group   The installation group.
## @param[in] Sudoers The sudoers supplementary file to be created for the
##                    installation user.
##
## @return the return code of the function execution.
################################################################################
configurePrerequisites() {
  local -r User="${1:-}"
  local -r Group="${2:-}"
  local -r Sudoers="${3:-}"
  local -i Retcode=$RETCODE_SUCCESS

  echoTitle 'Configuring system pre-requisites'

  traceParameter $Retcode "$DESCRIPTION_INSTALLATION_USER" "$User"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_INSTALLATION_GROUP" "$Group"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_INSTALLATION_SUDOERS" "$Sudoers"
  Retcode=$?

  # Create the installation group. #

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    if [[ $(getent group "$Group") ]] ; then
      echoInfo "${DESCRIPTION_INSTALLATION_GROUP} already exists: ${Group}"
    else
      executeCommand sudo '/usr/sbin/groupadd' "$Group"
      processCommandCode $? "Failed to create ${DESCRIPTION_INSTALLATION_GROUP}: ${Group}"
    fi
    Retcode=$?
  fi

  # Create the installation user. #

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    local Output1=''
    local Output2=''
    echo "id ${User}"
    Output1=`id "$User"`
    Retcode=$?
    echoNotice "returned ${Retcode}"
    if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
      echoInfo "${DESCRIPTION_INSTALLATION_USER} already exists: ${User}"
      echo "echo \"${Output1}\" | awk -F ' ' '{ print \$2 }' | awk -F '(' '{ print \$2 }' | tr -d ')'"
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
      executeCommand sudo '/usr/sbin/useradd' '-g' "$Group" '–s' '/usr/sbin/nologin' "$User"
      processCommandCode $? "Failed to create ${DESCRIPTION_INSTALLATION_USER}: ${User}:${Group}"
      Retcode=$?
    fi
  fi

  # Add the installation user to the operating systems's list of sudoers. #

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand sudo 'test' '-r' "$Sudoers"
    if [[ 0 -eq $? ]] ; then
      echoNotice "${DESCRIPTION_INSTALLATION_SUDOERS} already exists: ${Sudoers}"
    else
      echoNotice "${DESCRIPTION_INSTALLATION_SUDOERS} not found: ${Sudoers}"
      echo "sudo cat >${Sudoers} <<EOF ... EOF"
      echo "cat >${Sudoers} <<EOF
# Created by ${PROGRAM} on $(date)
# Grant sudo privileges to the Oracle installation user
${User} ALL=(ALL) NOPASSWD:ALL
EOF" | sudo sh
      processCommandCode $? "Failed to create ${DESCRIPTION_INSTALLATION_SUDOERS}: ${Sudoers}"
    fi
    Retcode=$?
  fi

  # Validate that the installation user sudoers supplementary file exists.

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand sudo 'test' '-f' "$Sudoers"
    processCommandCode $? "${DESCRIPTION_INSTALLATION_SUDOERS} is inaccessible: ${Sudoers}"
    Retcode=$?
  fi

  # Install pre-requisite system libraries. #

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand sudo 'yum' '-y' 'install' 'nfs-utils'
    processCommandCode $? "Failed to install pre-requisite system libraries"
    Retcode=$?
  fi

##TODO: Adjust level of system cache.

  return $Retcode
}

################################################################################
## @fn copyDatabaseSoftware
##
## @brief Copy the Oracle Database software from the repository to the Oracle
##        Home directory.
##
## @param[in] User       The installation user.
## @param[in] Group      The installation group.
## @param[in] Repository The source directory from which to copy the Oracle
##                       software.
## @param[in] Home       The destination directory where to copy the Oracle
##                       software.
##
## @return the return code of the function execution.
################################################################################
copyDatabaseSoftware() {
  local -r User="${1:-}"
  local -r Group="${2:-}"
  local -r Repository="${3:-}"
  local -r Home="${4:-}"
  local -r Requirements="${Home}/cv/admin/cvu_config"
  local -i Retcode=$RETCODE_SUCCESS

  echoTitle "Copying the ${DESCRIPTION_PRODUCT_DATABASE} files"

  traceParameter $Retcode "$DESCRIPTION_INSTALLATION_USER" "$User"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_INSTALLATION_GROUP" "$Group"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_DATABASE_REPOSITORY" "$Repository"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_DATABASE_HOME" "$Home"
  Retcode=$?

  # Validate that the software repository directory can be read. #

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    if [[ ! -d "$Repository" ]] || [[ ! -r "$Repository" ]] ; then
      echoError $RETCODE_OPERATION_ERROR "${DESCRIPTION_DATABASE_REPOSITORY} is inaccessible: ${Repository}"
    else
      echo "cd ${Repository}"
      cd "$Repository"
      processCommandCode $? "Failed to change current directory to: ${Repository}"
    fi
    Retcode=$?
  fi

  # Validate that the home directory can be written. #

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand sudo '-u' "$User" 'test' '-d' "$Home"
    processCommandCode $? "${DESCRIPTION_DATABASE_HOME} is inaccessible: ${Home}"
    Retcode=$?
  fi

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand sudo '-u' "$User" 'test' '-w' "$Home"
    processCommandCode $? "${DESCRIPTION_DATABASE_HOME} is not writable: ${Home}"
    Retcode=$?
  fi

  # Copy the software. #

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand sudo '-u' "$User" 'test' '-f' "$Requirements"
    if [[ 0 -eq $? ]] ; then
      echoNotice "Software already copied: ${Home}"
    else
      echoNotice "Software not already copied: ${Home}"
      echo "tar cf - . | (cd ${Home} ; sudo -u ${User} tar xf -)"
      tar cf - . | (cd "$Home" ; sudo -u "$User" tar xf -)
      processCommandCode $? "Failed to copy ${DESCRIPTION_PRODUCT_DATABASE} files with user '${User}' from '${Repository}' to '${Home}'"
    fi
    Retcode=$?
  fi

  # Remove requirement for maximum OS version EL8.1 (Hack). #

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
## TODO: Check version (example OL 7)
    local -r HACK='CV_ASSUME_DISTID=OEL8'
    echo "sudo grep ${HACK} ${Requirements}"
    if [[ -z $(sudo grep "$HACK" "$Requirements") ]]; then
      echoNotice "Software not hacked for OL8"      
      local Output=''
      echo "echo ${HACK}.1 | sudo tee -a ${Requirements}"
      Output=`echo "${HACK}.1" | sudo tee -a "$Requirements"`
      processCommandCode $? "Failed to modify file: ${Requirements}"
    else
      echoNotice "Software already hacked for OL8"      
    fi
    Retcode=$?
  fi

  return $Retcode
}

################################################################################
## @fn createDirectories
##
## @brief Create the directories used by the Oracle products.
##
## @param[in] Inventory    The inventory directory of the Oracle installation
##                         (ex. /u01/app/oraInventory).
## @param[in] Base         The base directory of the Oracle installation
##                         (ex. /u01/app/oracle).
## @param[in] User         The installation user.
## @param[in] Group        The installation group.
## @param[in] DatabaseHome The home directory of the Oracle Database.
## @param[in] ManagerHome  The home directory of the Oracle Enterprise Manager.
## @param[in] AgentBase    The base directory of the Oracle Enterprise Manager
##                         agent.
##
## @return the return code of the function execution.
################################################################################
createDirectories() {
  local -r Inventory="${1:-}"
  local -r Base="${2:-}"
  local -r User="${3:-}"
  local -r Group="${4:-}"
  local -r DatabaseHome="${5:-}"
  local -r ManagerHome="${6:-}"
  local -r AgentBase="${7:-}"
  local -r PERMISSIONS='755'
  local -i Retcode=$RETCODE_SUCCESS

  echoTitle 'Creating the Oracle products directories'

  traceParameter $Retcode "$DESCRIPTION_INSTALLATION_INVENTORY" "$Inventory"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_INSTALLATION_BASE" "$Base"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_INSTALLATION_USER" "$User"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_INSTALLATION_GROUP" "$Group"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_DATABASE_HOME" "$DatabaseHome"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_MANAGER_HOME" "$ManagerHome"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_AGENT_BASE" "$AgentBase"
  Retcode=$?

  # Create the installation inventory directory. #

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    if [[ -d "$Inventory" ]] ; then
      echoInfo "${DESCRIPTION_INSTALLATION_INVENTORY} already exists: ${Inventory}"
      Retcode=$?
    else
      executeCommand sudo 'mkdir' '-m' "$PERMISSIONS" '-p' "$Inventory"
      processCommandCode $? "Failed to create ${DESCRIPTION_INSTALLATION_INVENTORY}: ${Inventory}"
      Retcode=$?
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand sudo 'chown' "${User}:${Group}" "$Inventory"
        processCommandCode $? "Failed to set ownership (${User}:${Group}) on ${DESCRIPTION_INSTALLATION_INVENTORY}: ${Inventory}"
        Retcode=$?
      fi
    fi
  fi

  # Create the installation base directory. #

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    if [[ -d "$Base" ]] ; then
      echoInfo "${DESCRIPTION_INSTALLATION_BASE} already exists: ${Base}"
      Retcode=$?
    else
      executeCommand sudo 'mkdir' '-m' "$PERMISSIONS" '-p' "$Base"
      processCommandCode $? "Failed to create ${DESCRIPTION_INSTALLATION_BASE}: ${Base}"
      Retcode=$?
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        executeCommand sudo 'chown' "${User}:${Group}" "$Base"
        processCommandCode $? "Failed to set ownership (${User}:${Group}) on ${DESCRIPTION_INSTALLATION_BASE}: ${Base}"
        Retcode=$?
      fi
    fi
  fi

  # Create the Oracle Database home directory. #

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    if [[ -d "$DatabaseHome" ]] ; then
      echoInfo "${DESCRIPTION_DATABASE_HOME} already exists: ${DatabaseHome}"
    else
      executeCommand sudo '-u' "$User" 'mkdir' '-m' "$PERMISSIONS" '-p' "$DatabaseHome"
      processCommandCode $? "Failed to create ${DESCRIPTION_DATABASE_HOME}: ${DatabaseHome}"
    fi
    Retcode=$?
  fi

  # Create the Oracle Enterprise Manager home directory. #

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    if [[ -d "$ManagerHome" ]] ; then
      echoInfo "${DESCRIPTION_MANAGER_HOME} already exists: ${ManagerHome}"
    else
      executeCommand sudo '-u' "$User" 'mkdir' '-m' "$PERMISSIONS" '-p' "$ManagerHome"
      processCommandCode $? "Failed to create ${DESCRIPTION_MANAGER_HOME}: ${ManagerHome}"
    fi
    Retcode=$?
  fi

  # Create the Oracle Enterprise Manager Agent base directory. #

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    if [[ -d "$AgentBase" ]] ; then
      echoInfo "${DESCRIPTION_AGENT_BASE} already exists: ${AgentBase}"
    else
      executeCommand sudo '-u' "$User" 'mkdir' '-m' "$PERMISSIONS" '-p' "$AgentBase"
      processCommandCode $? "Failed to create ${DESCRIPTION_AGENT_BASE}: ${AgentBase}"
    fi
    Retcode=$?
  fi

  return $Retcode
}

################################################################################
## @fn displayOptions
##
## @brief Display the program options.
##
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
  echoOption "$DESCRIPTION_INSTALLATION_SUDOERS" "$INSTALLATION_SUDOERS"
  echoOption "$DESCRIPTION_DATABASE_BASE" "$DATABASE_BASE"
  echoOption "$DESCRIPTION_DATABASE_HOME" "$DATABASE_HOME"
  echoOption "$DESCRIPTION_DATABASE_NAME" "${DATABASE_NAME}.${DATABASE_DOMAIN}"
  echoOption "$DESCRIPTION_DATABASE_DATA" "$DATABASE_DATA"
  echoOption "$DESCRIPTION_DATABASE_RECOVERY" "$DATABASE_RECOVERY"
  echoOption "$DESCRIPTION_MANAGER_BASE" "$MANAGER_BASE"
  echoOption "$DESCRIPTION_MANAGER_HOME" "$MANAGER_HOME"
  echoOption "$DESCRIPTION_AGENT_BASE" "$AGENT_BASE"
  echoOption "$DESCRIPTION_DATABASE_RESPONSE" "$DATABASE_RESPONSE"
  echoOption "$DESCRIPTION_MANAGER_RESPONSE" "$MANAGER_RESPONSE"
  return $RETCODE_SUCCESS
}

################################################################################
## @fn generateDatabaseResponse
##
## @brief Generate the response file used to install the Oracle Database in
##        silent mode.
##
## @param[in] Inventory The inventory directory of the Oracle installation
##                      (ex. /u01/app/oraInventory).
## @param[in] User      The installation user.
## @param[in] Group     The installation group.
## @param[in] Base      The base directory of the Oracle Database.
## @param[in] Home      The home directory of the Oracle Database.
## @param[in] Database  The name of the database.
## @param[in] Domain    The domain name of the database.
## @param[in] Data      The data directory of the Oracle Database.
## @param[in] Recovery  The recovery directory of the Oracle Database.
## @param[in] Password  The password for the database "sys" account.
## @param[in] Response  The filename of the response file to generate.
##
## @return the return code of the function execution.
################################################################################
generateDatabaseResponse() {
  local -r Inventory="${1:-}"
  local -r User="${2:-}"
  local -r Group="${3:-}"
  local -r Base="${4:-}"
  local -r Home="${5:-}"
  local -r Database="${6:-}"
  local -r Domain="${7:-}"
  local -r Data="${8:-}"
  local -r Recovery="${9:-}"
  local -r Password="${10:-}"
  local -r Response="${11:-}"
  local -i Retcode=$RETCODE_SUCCESS

  echoTitle "Generating the ${DESCRIPTION_DATABASE_RESPONSE}: ${Response}"

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
  traceParameter $Retcode "$DESCRIPTION_DATABASE_NAME" "$Database"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_DATABASE_DOMAIN" "$Domain"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_DATABASE_DATA" "$Data"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_DATABASE_RECOVERY" "$Recovery"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_DATABASE_RESPONSE" "$Response"
  Retcode=$?

  # Generate the automated Oracle Database installation response file. #

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand sudo '-u' "$User" 'test' '-r' "$Response"
    if [[ 0 -eq $? ]] ; then
      echoNotice "${DESCRIPTION_DATABASE_RESPONSE} already exists: ${Response}"
    else
      echoNotice "${DESCRIPTION_DATABASE_RESPONSE} not found: ${Response}"
      echo "sudo -u ${User} cat >${Response} <<EOF ... EOF"
      echo "cat >${Response} <<EOF
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
oracle.install.db.config.starterdb.globalDBName=${Database}
oracle.install.db.config.starterdb.SID=${Database}
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
EOF" | sudo -u "$User" sh
      processCommandCode $? "${DESCRIPTION_DATABASE_RESPONSE} was not created: ${Response}"
    fi
    Retcode=$?
  fi

  # Limit file permissions. #

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand sudo 'chmod' '440' "$Response"
    processCommandCode $? "Unable to limit file permissions on ${DESCRIPTION_DATABASE_RESPONSE}: ${Response}"
    Retcode=$?
  fi

  # Validate that the automated Oracle Database installation response file is accessible by the installation user. #

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand sudo '-u' "$User" 'test' '-r' "$Response"
    processCommandCode $? "${DESCRIPTION_DATABASE_RESPONSE} is inaccessible: ${Response}"
    Retcode=$?
  fi

  return $Retcode
}

################################################################################
## @fn generateManagerResponse
##
## @brief Generate the response file used to install the Oracle Enterprise
##        Manager in silent mode.
##
## @param[in] Inventory        The inventory directory of the Oracle
##                             installation (ex. /u01/app/oraInventory).
## @param[in] User             The installation user.
## @param[in] Group            The installation group.
## @param[in] Hostname         The hostname of the machine.
## @param[in] Database         The name of the database.
## @param[in] DatabaseData     The data directory of the Oracle Database.
## @param[in] DatabasePassword The password for the database "sys" account.
## @param[in] ManagerBase      The base directory of the Oracle Enterprise
##                             Manager.
## @param[in] Home             The home directory of the Oracle Enterprise
##                             Manager.
## @param[in] AgentBase        The base directory of the Oracle Enterprise
##                             Manager Agent.
## @param[in] Response         The filename of the response file to generate.
##
## @return the return code of the function execution.
################################################################################
generateManagerResponse() {
  local -r Inventory="${1:-}"
  local -r User="${2:-}"
  local -r Group="${3:-}"
  local -r Hostname=${4:-}
  local -r Database="${5:-}"
  local -r DatabaseData="${6:-}"
  local -r DatabasePassword="${7:-${DEFAULT_DATABASE_PASSWORD}}"
  local -r ManagerBase="${8:-}"
  local -r ManagerHome="${9:-}"
  local -r AgentBase="${10:-}"
  local -r ManagerData="${ManagerBase}/oradata"
  local -r WeblogicPassword=${DEFAULT_DATABASE_PASSWORD}
  local -r RepositoryPassword=${DEFAULT_DATABASE_PASSWORD}
  local -r AgentPassword=${DEFAULT_DATABASE_PASSWORD}
  local -r CryptoPassword=${DEFAULT_DATABASE_PASSWORD}
  local -r Response="${11:-}"
  local -i Retcode=$RETCODE_SUCCESS

  echoTitle "Generating the ${DESCRIPTION_MANAGER_RESPONSE}: ${Response}"

  traceParameter $Retcode "$DESCRIPTION_INSTALLATION_INVENTORY" "$Inventory"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_INSTALLATION_USER" "$User"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_INSTALLATION_GROUP" "$Group"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_INSTALLATION_HOSTNAME" "$Hostname"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_DATABASE_NAME" "$Database"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_DATABASE_DATA" "$DatabaseData"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_MANAGER_BASE" "$ManagerBase"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_MANAGER_HOME" "$ManagerHome"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_AGENT_BASE" "$AgentBase"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_MANAGER_RESPONSE" "$Response"
  Retcode=$?

  # Generate the automated Oracle Enterprise Manager installation response file. #

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand sudo '-u' "$User" 'test' '-r' "$Response"
    if [[ 0 -eq $? ]] ; then
      echoNotice "${DESCRIPTION_MANAGER_RESPONSE} already exists: ${Response}"
    else
      echoNotice "${DESCRIPTION_MANAGER_RESPONSE} not found: ${Response}"
      echo "sudo -u ${User} cat >${Response} <<EOF ... EOF"
      echo "cat >${Response} <<EOF
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
ORACLE_INSTANCE_HOME_LOCATION=${ManagerBase}/gc_inst
# Repository
DATABASE_HOSTNAME=${Hostname}
LISTENER_PORT=1521
SERVICENAME_OR_SID=${Database}
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
EOF" | sudo -u "$User" sh
      processCommandCode $? "${DESCRIPTION_MANAGER_RESPONSE} was not created: ${Response}"
    fi
    Retcode=$?
  fi

  # Limit file permissions. #

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand sudo 'chmod' '440' "$Response"
    processCommandCode $? "Unable to limit file permissions on ${DESCRIPTION_MANAGER_RESPONSE}: ${Response}"
    Retcode=$?
  fi

  # Validate that the Oracle automated Enterprise Manager installation response file is accessible by the installation user. #

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand sudo '-u' "$User" 'test' '-r' "$Response"
    processCommandCode $? "${DESCRIPTION_MANAGER_RESPONSE} is inaccessible: ${Response}"
    Retcode=$?
  fi
  
  return $Retcode
}

################################################################################
## @fn installDatabase
##
## @brief Install and launch the Oracle Database.
##
## @param[in] Inventory The inventory directory of the Oracle installation
##                      (ex. /u01/app/oraInventory).
## @param[in] User      The installation user.
## @param[in] Home      The home directory of the Oracle Database.
## @param[in] Response  The response file used to install the Oracle Database.
##
## @return the return code of the function execution.
################################################################################
installDatabase() {
  local -r Inventory="${1:-}"
  local -r User="${2-:-}"
  local -r Home="${3:-}"
  local -r Response="${4:-}"
  local -r InventoryInstaller="${Inventory}/orainstRoot.sh"
  local -r DatabaseInstaller="${Home}/root.sh"
  local -i Retcode=$RETCODE_SUCCESS

  echoTitle "Installing the ${DESCRIPTION_PRODUCT_DATABASE}"

  traceParameter $Retcode "$DESCRIPTION_INSTALLATION_INVENTORY" "$Inventory"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_INSTALLATION_USER" "$User"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_DATABASE_HOME" "$Home"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_DATABASE_RESPONSE" "$Response"
  Retcode=$?

  export ORACLE_HOME="$Home"

  # Change current working directory to Oracle Home directory. #

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    if [[ ! -d "$Home" ]] || [[ ! -x "$Home" ]] ; then
      echoError $RETCODE_OPERATION_ERROR "${DESCRIPTION_DATABASE_HOME} is inaccessible: ${Home}"
    else
      echo "cd ${Home}"
      cd "$Home"
      processCommandCode $? "Failed to change current working directory to: ${Home}"
    fi
    Retcode=$?
  fi

  # Run the Oracle Database installation utility with the installation user. #

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand sudo '-E' '-u' "$User" './runInstaller' '-silent' '-responseFile' "$Response"
    processCommandCode $? 'Error occurred when running Oracle installer (runInstaller)'
    Retcode=$?
  fi

  # Run the Oracle inventory installation script, if it exists, with the installation user. #

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ -x "$InventoryInstaller" ]] ; then
    executeCommand sudo '-E' '-u' "$User" 'sudo' "$InventoryInstaller"
    processCommandCode $? "Error occurred when running Oracle Inventory installer (${InventoryInstaller})"
    Retcode=$?
  fi

  # Run the Oracle Database root installation script with the installation user. #

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] && [[ -x "$DatabaseInstaller" ]] ; then
    executeCommand sudo '-E' '-u' "$User" 'sudo' "$DatabaseInstaller"
    processCommandCode $? "Error occurred when running Oracle Root installer (${DatabaseInstaller})"
    Retcode=$?
  fi

  # Configure the Oracle Database installation with the installation user. #

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand 'sudo' '-E' '-u' "$User" './runInstaller' '-executeConfigTools' '-silent' '-responseFile' "$Response"
    processCommandCode $? 'Error occurred when running Oracle installer (runInstaller -executeConfigTools)'
    Retcode=$?
  fi

  return $Retcode
}

###############################################################################
## @fn installManager
##
## @brief Install and launch the Oracle Enterprise Manager.
##
## @param[in] Stage      A staging directory to use during the installation.
## @param[in] User       The installation user.
## @param[in] Repository The source directory where the Oracle Enterprise
##                       Manager download files were unzipped.
## @param[in] Response   The response file used to install the Oracle
##                       Enterprise Manager
##
## @return the return code of the function execution.
################################################################################
installManager() {
  local -r Stage="${1-:-}"
  local -r User="${2-:-}"
  local -r Repository="${3-:-}"
  local -r Response="${4-:-}"
  local -i Retcode=$RETCODE_SUCCESS

  echoTitle "Installing the ${DESCRIPTION_PRODUCT_MANAGER}"

  traceParameter $Retcode "$DESCRIPTION_INSTALLATION_STAGE" "$Stage"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_INSTALLATION_USER" "$User"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_MANAGER_REPOSITORY" "$Repository"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_MANAGER_RESPONSE" "$Response"
  Retcode=$?

  # Change current working directory to Oracle Home directory. #

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    if [[ ! -d "$Repository" ]] || [[ ! -x "$Repository" ]] ; then
      echoError $RETCODE_OPERATION_ERROR "${DESCRIPTION_MANAGER_REPOSITORY} is inaccessible: ${Repository}"
    else
      echo "cd ${Repository}"
      cd "$Repository"
      processCommandCode $? "Failed to change current working directory to: ${Repository}"
    fi
    Retcode=$?
  fi

  # Run the Oracle Enterprise Manager installation utility with the installation user. #

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand sudo '-E' '-u' "$User" './em13500_linux64.bin' '-silent' '-responseFile' "$Response" "-J-Djava.io.tmpdir=${Stage}"
    processCommandCode $? "Failed to install Oracle Enterprise Manager: ${Repository}/em13500_linux64.bin"
    Retcode=$?
  fi

## TODO: Poke holes in Firewalld
#firewall-cmd --permanent --zone=public --add-port=7102/tcp
#firewall-cmd --permanent --zone=public --add-port=7803/tcp

  return $Retcode
}

################################################################################
## @fn uninstallDatabase
##
## @brief Uninstall the Oracle Database.
##
## @param[in] User The installation user.
## @param[in] Home The home directory of the Oracle Database.
##
## @return the return code of the function execution.
################################################################################
uninstallDatabase() {
  local -r User="${1-:-}"
  local -r Home="${2:-}"
  local -r Deinstaller="${Home}/deinstall/deinstall"
  local Response=''
  local -i Retcode=$RETCODE_SUCCESS

  echoTitle "Uninstalling the ${DESCRIPTION_PRODUCT_DATABASE}"

  traceParameter $Retcode "$DESCRIPTION_INSTALLATION_USER" "$User"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_DATABASE_HOME" "$Home"
  Retcode=$?

  # Validate that the Oracle Database de-installer is present and usable by the installation user. #

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand sudo '-u' "$User" 'test' '-x' "$Deinstaller"
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
    done < <(sudo -u "$User" "$Deinstaller" -silent -checkonly)
    if [[ -n "$Right" ]] ; then
      Response=$(echo "$Right" | awk -F \' '{ print $2 }')
    fi
    if [[ -z "$Response" ]] ; then
      echoError $RETCODE_OPERATION_ERROR "Failed to obtain a response file from the ${DESCRIPTION_PRODUCT_DATABASE} de-installer program: ${Deinstaller}"
      Retcode=$?
    fi
  fi

  # Validate that the automated uninstallation response file is present and accessible to the installation user. #

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand sudo '-u' "$User" 'test' '-r' "$Response"
    processCommandCode $? "${DESCRIPTION_DATABASE_RESPONSE} is inaccessible: ${Response}"
    Retcode=$?
  fi

  # Uninstall the Oracle Database software. #

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand sudo '-u' "$User" "$Deinstaller" '-silent' '-paramfile' "$Response"
    processCommandCode $? "The ${DESCRIPTION_PRODUCT_DATABASE} de-installer program encountered an error (response file = ${Response})"
    Retcode=$?
  fi

  return $?
}

################################################################################
## @fn uninstallManager
##
## @brief Uninstall the Oracle Enterprise Manager.
##
## @param[in] Stage A staging directory to use during the installation.
## @param[in] User  The installation user.
## @param[in] Home  The home directory of the Oracle Database.
##
## @return the return code of the function execution.
################################################################################
uninstallManager() {
  local -r Stage="${1-:-}"
  local -r User="${2-:-}"
  local -r Home="${3:-}"
  local -r Deinstaller='/tmp/EMDeinstall.pl'
  local Response=''
  local -i Retcode=$RETCODE_SUCCESS

  echoTitle "Uninstalling the ${DESCRIPTION_PRODUCT_MANAGER}"

  traceParameter $Retcode "$DESCRIPTION_INSTALLATION_USER" "$User"
  Retcode=$?
  traceParameter $Retcode "$DESCRIPTION_DATABASE_HOME" "$Home"
  Retcode=$?

#sudo -u ${User} cp ${INSTALL_BASE}/sysman/install/EMDeinstall.pl ${TEMP_UNINSTALL}

  if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
    executeCommand sudo 'su' '-' ${User} '-s' '/usr/bin/bash' '-c' "${INSTALL_BASE}/perl/bin/perl ${Deinstaller} -mwHome ${INSTALL_BASE} -stageLoc ${Stage}"
    processCommandCode $? "The ${DESCRIPTION_PRODUCT_MANAGER} de-installer program encountered an error"
    Retcode=$?
  fi

#sudo -u ${User} cp /u01/app/oracle/middleware/sysman/install/EMDeinstall.pl ${Deinstaller}


  return 0
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
declare DATABASE_DOMAIN=''
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
    "$OPTION_DATABASE_DOMAIN")
      setOption "$Option" "$OptionValue" 'DATABASE_DOMAIN'
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

  setOption "$OPTION_DATABASE_DOMAIN" "$DEFAULT_DATABASE_DOMAIN" 'DATABASE_DOMAIN' $Retcode $VALUE_TRUE
  Retcode=$?
  declare -r DATABASE_DOMAIN

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
  declare -r INSTALLATION_SUDOERS="$DEFAULT_INSTALLATION_SUDOERS"
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
        configurePrerequisites "$INSTALLATION_USER" "$INSTALLATION_GROUP" "$INSTALLATION_SUDOERS"
        Retcode=$?
      fi
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        createDirectories "$INSTALLATION_INVENTORY" "$INSTALLATION_BASE" "$INSTALLATION_USER" "$INSTALLATION_GROUP" "$DATABASE_HOME" "$MANAGER_HOME" "$AGENT_BASE"
        Retcode=$?
      fi
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        copyDatabaseSoftware "$INSTALLATION_USER" "$INSTALLATION_GROUP" "$DATABASE_REPOSITORY" "$DATABASE_HOME"
        Retcode=$?
      fi
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        generateDatabaseResponse "$INSTALLATION_INVENTORY" "$INSTALLATION_USER" "$INSTALLATION_GROUP" "$DATABASE_BASE" "$DATABASE_HOME" "$DATABASE_NAME" "$DATABASE_DOMAIN" "$DATABASE_DATA" "$DATABASE_RECOVERY" "$DATABASE_PASSWORD" "$DATABASE_RESPONSE"
        Retcode=$?
      fi
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        generateManagerResponse "$INSTALLATION_INVENTORY" "$INSTALLATION_USER" "$INSTALLATION_GROUP" "$INSTALLATION_HOSTNAME" "$DATABASE_NAME" "$DATABASE_DATA" "$DATABASE_PASSWORD" "$MANAGER_BASE" "$MANAGER_HOME" "$AGENT_BASE" "$MANAGER_RESPONSE"
        Retcode=$?
      fi
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        installDatabase "$INSTALLATION_INVENTORY" "$INSTALLATION_USER" "$DATABASE_HOME" "$DATABASE_RESPONSE"
        Retcode=$?
      fi
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        configureDatabase "$INSTALLATION_USER" "$DATABASE_HOME" "$DATABASE_NAME" "$DATABASE_PASSWORD"
        Retcode=$?
      fi
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        installManager "$INSTALLATION_STAGE" "$INSTALLATION_USER" "$MANAGER_REPOSITORY" "$MANAGER_RESPONSE"
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
#      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
#        uninstallManager "$INSTALLATION_USER" "$DATABASE_HOME"
#        Retcode=$?
#      fi
      if [[ $RETCODE_SUCCESS -eq $Retcode ]] ; then
        uninstallDatabase "$INSTALLATION_USER" "$DATABASE_HOME"
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
