#!/usr/bin/env bash
#
# redeploy the Solr ETL from github
#
if [[ $# -ne 1 ]] ;
then
  echo
  echo "Usage: $0 <version>"
  echo
  exit 1
fi

cd
SOLRETLDIR=${HOME}/solrdatasources
SOLR_REPO=${HOME}/cspace-solr-ucb
# check to see we are plausibly able to do something...
if [ ! -d ${SOLR_REPO} ];
then
   echo "Solr repo ${SOLR_REPO} not found in this directory. Please clone from GitHub."
   exit 1
fi
if [ ! -d ${SOLRETLDIR} ];
then
   echo "Solr ETL directory $SOLRETLDIR not found. Assuming this is a fresh install"
else
    # make a backup of the current ETL directory just in case
    YYYYMMDD=`date +%Y%m%d`
    BACKUPDIR=${SOLRETLDIR}.${YYYYMMDD}
    if [ -d ${BACKUPDIR} ];
    then
       echo "Backup ETL directory ${BACKUPDIR} already exists. Please move or remove it and try again"
       exit 1
    fi
    mv ${SOLRETLDIR} ${BACKUPDIR}
fi

mkdir ${SOLRETLDIR}

# deploy fresh code from github
cd ${SOLR_REPO}
git checkout main
git pull -v
git checkout $1
cp utilities/o*.sh ${HOME}
cp utilities/checkstatus.sh ${HOME}

cd
rsync -a --exclude .git --exclude .gitignore --exclude solr-cores --exclude utilities ${SOLR_REPO}/ ${SOLRETLDIR}/

# try to put botgarden's pickle file back; it takes hours to recreate from scratch.
if [ ! -f ${BACKUPDIR}/botgarden/gbif/names.pickle ]
then
    echo "${BACKUPDIR}/botgarden/gbif/names.pickle not found. UCBG refresh will try to rebuild it from scratch"
    echo "which takes about 8-10 hours; consider finding a copy and putting it where it belongs"
else
    cp ${BACKUPDIR}/botgarden/gbif/names.pickle ${SOLRETLDIR}/botgarden/gbif
fi
echo
echo "Solr ETL pipeline deploy complete."
echo
echo "Double-check configuration of code in ${SOLRETLDIR}!"
