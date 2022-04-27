
  if [[ ${USER} == 'app_cspace' ]]; then
    echo
    echo "USER is 'app_cspace', assuming deployment is on AWS/EC2"
    echo
    export SOLR_CACHE_DIR="/cspace/solr_cache"
    export SOLR_LOG_DIR="/cspace/solr_logs"
  elif [[ ${USER} == 'app_webapps' ]]; then
    echo
    echo "Assuming deployment is on RTL server"
    echo
    export SOLR_CACHE_DIR="/tmp"
    export SOLR_LOG_DIR="${HOME}/logs"
  else
    echo
    echo "Assuming deployment is local"
    echo
    export SOLR_CACHE_DIR="/tmp"
    export SOLR_LOG_DIR="${HOME}/logs"
  fi
