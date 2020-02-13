#
# redeploy the Solr ETL from github
#
# check to see we are plausibly able to do something...
cd
SOLRETLDIR=solrdatasources
SOLR_REPO=cspace-solr-ucb
if [ ! -d $SOLR_REPO ];
then
   echo "Solr repo $SOLR_REPO not found in this directory. Please clone from GitHub."
   exit 1
fi
if [ ! -d $SOLRETLDIR ];
then
   echo "Solr ETL directory $SOLRETLDIR not found. Assuming this is a fresh install"
else
    # make a backup of the current ETL directory just in case
    YYMMDD=`date +%y%m%d`
    BACKUPDIR=${SOLRETLDIR}.${YYMMDD}
    if [ -d $BACKUPDIR ];
    then
       echo "Backup ETL directory $BACKUPDIR already exists. Please move or remove it and try again"
       exit 1
    fi
    mv ${SOLRETLDIR} ${BACKUPDIR}
fi

mkdir ${SOLRETLDIR}

# deploy fresh code from github
cd ${SOLR_REPO}
git pull -v
cp utilities/o*.sh ~
cp utilities/checkstatus.sh ~
cp utilities/redeploy-etl.sh ~

cd
rsync -a --exclude .git --exclude .gitignore --exclude solr-cores --exclude utilities ~/cspace-solr-ucb/ solrdatasources/

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
