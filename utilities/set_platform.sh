#!/bin/bash

if [[ ${LOGNAME} == 'app_cspace' ]]; then
  export PLATFORM="AWS/EC2"
  export HOMEDIR="/cspace"
  export SOLR_CACHE_DIR="/cspace/solr_cache"
  export SOLR_LOG_DIR="/cspace/solr_logs"
elif [[ ${LOGNAME} == 'app_webapps' ]]; then
  export PLATFORM="RTL server"
  export HOMEDIR=${HOME}
  export SOLR_CACHE_DIR="/tmp"
  export SOLR_LOG_DIR="${HOME}/logs"
else
  export PLATFORM="local"
  export HOMEDIR=${HOME}
  export SOLR_CACHE_DIR="/tmp"
  export SOLR_LOG_DIR="${HOME}/logs"
fi
if [[ "$1" == "-v" ]]; then
  echo
  echo "LOGNAME is ${LOGNAME}"
  echo "Assuming deployment is ${PLATFORM}"
  echo "HOMEDIR: ${HOMEDIR}"
  echo "SOLR_CACHE_DIR: ${SOLR_CACHE_DIR}"
  echo "SOLR_LOG_DIR: ${SOLR_LOG_DIR}"
  echo
fi
