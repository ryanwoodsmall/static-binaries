#!/usr/bin/env bash

set -eu
set -o pipefail

: ${specialtools="busybox toybox sbase-box ubase-box coreutils dropbearmulti"}
: ${toolorder=""}
: ${allowroot="0"}
: ${forceoverwrite="0"}

function failexit() {
  echo "${BASH_SOURCE[0]}: ${@}" 1>&2
  exit 1
}

: ${installdir:=""}
if [ -z "${installdir}" ] ; then
  if [ ${#} -lt 1 ] ; then
    failexit "please provide a directory to which tools will be installed or set \${installdir} environment variable"
  else
    installdir="${1}"
  fi
fi

test "${UID}" -eq 0 && { test "${allowroot}" -eq 1 || failexit "\${allowroot} set to ${allowroot} - set to 1 to allow running as root" ; }

test -z "${installdir}" && failexit "\${installdir} is empty"
test -e "${installdir}" || mkdir -p "${installdir}"
test -e "${installdir}" || failexit "could not create ${installdir}"

td="$(cd $(dirname $(realpath ${BASH_SOURCE[0]})) && pwd)"
test -e "${td}/common.sh" && source "${td}/common.sh" || failexit "could not source ${td}/common.sh"

export archddir="${td}/${archdir}"
test -e "${archdir}" || failexit "no such directory ${archdir}"
if [ -z "${toolorder}" ] ; then
  if [ ${forceoverwrite} -eq 0 ] ; then
    toolorder="${specialtools}"
  else
    toolorder="$(echo ${specialtools} | tr ' ' '\n' | tac | xargs echo)"
  fi
  for p in $(find "${archdir}" -maxdepth 1 -mindepth 1 ! -type d -exec basename {} \; | sort | egrep -v "^(${specialtools// /|})$") ; do
    if [ ${forceoverwrite} -eq 0 ] ; then
      toolorder="${p} ${toolorder}"
    else
      toolorder="${toolorder} ${p}"
    fi
  done
fi

function special_install() {
  if [ ${#} -lt 1 ] ; then
    failexit "${FUNCNAME}: provide a tool name to install"
  fi
  local t="${1}"
  local f="${archdir}/${t}"
  local a
  local l
  local m
  if [[ ${t} == busybox ]] ; then
    a="--list"
  elif [[ ${t} == coreutils ]] ; then
    a='--help 2>&1 | sed -n "/^Built-in programs:/,/^$/p" | grep -v ^Built-in | xargs echo'
  elif [[ ${t} == dropbearmulti ]] ; then
    a='--help 2>&1 | sed "s/ or / - /g" | tr "-" "\n" | grep "^'
    a+="'"
    a+='" | tr -d "'
    a+="'"
    a+='"'
  elif [[ ${t} =~ ^(toybox|sbase-box|ubase-box)$ ]] ; then
    a=""
  else
    true
    return
  fi
  echo "installing ${t} symlinks in ${installdir}"
  for l in $(eval "${f} ${a}") ; do
    m="installing ${t} symlink to ${l}"
    l="${installdir}/${l}"
    if [ ! -e "${l}" ] ; then
      echo "${m}"
      ln -sf "${t}" "${l}"
    else
      if [ ${forceoverwrite} -eq 0 ] ; then
        echo "not overwriting ${l}"
        true
      else
        echo "${m}"
        ln -sf "${t}" "${l}"
      fi
    fi
  done
  unset f a l m
}

function install_tool() {
  if [ ${#} -lt 1 ] ; then
    failexit "${FUNCNAME}: provide a tool name to install"
  fi
  local t="${1}"
  echo "installing ${t} to ${installdir}"
  local f="${archdir}/${t}"
  test -e "${f}" || failexit "no such file ${f}"
  special_install "${t}"
  if [ -e "${installdir}/${t}" ] ; then
    if [ ${forceoverwrite} -eq 0 ] ; then
      echo "not overwriting ${installdir}/${t}"
      return
    fi
  fi
  install -m 0755 "${f}" "${installdir}/${t}"
  unset t f a
}

for t in ${toolorder} ; do
  install_tool "${t}"
done
