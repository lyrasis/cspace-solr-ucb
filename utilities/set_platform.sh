
if [[ ${USER} == 'app_cspace' ]]; then
  export PLATFORM="AWS/EC2"
  export SOLR_CACHE_DIR="/cspace/solr_cache"
  export SOLR_LOG_DIR="/cspace/solr_logs"
elif [[ ${USER} == 'app_webapps' ]]; then
  export PLATFORM="RTL server"
  export SOLR_CACHE_DIR="/tmp"
  export SOLR_LOG_DIR="${HOME}/logs"
else
  export PLATFORM="local"
  export SOLR_CACHE_DIR="/tmp"
  export SOLR_LOG_DIR="${HOME}/logs"
fi
if [[ "$1" == "-v" ]]; then
  echo
  echo "User is ${USER}"
  echo "Assuming deployment is ${PLATFORM}"
  echo "SOLR_CACHE_DIR: ${SOLR_CACHE_DIR}"
  echo "SOLR_LOG_DIR: ${SOLR_LOG_DIR}"
  echo
fi