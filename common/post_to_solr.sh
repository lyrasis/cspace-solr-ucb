#!/usr/bin/env bash
TENANT=$1
CORE=$2
CONTACT=$3
# MINIMUM is an approximate lower bound on the number of rows there should
# be, based on data as of 2019-09-11. It may need to be periodically adjusted.
MINIMUM=$4
BLOB_COLUMN=$5
FILE_PART=$6
##############################################################################
# a helper function
##############################################################################
function notify()
{
  echo "$1"
  echo "$1" | mail -s "$2" -- ${CONTACT}
}
# nb: in general the name of the core and the name of the file are related.
# however, sometimes the same core may get refreshed with more than one file.
# ergo, we need to (optionally) distinguish CORE and FILE.
if [[ "${FILE_PART}" == "" ]]; then
  FILE_PART=${CORE}
fi
##############################################################################
# check if we have enough data to be worth refreshing...
##############################################################################
CSVFILE="4solr.${TENANT}.${FILE_PART}.csv"
if [[ ! -e ${CSVFILE} ]]; then
  MSG="Could not find ${CSVFILE} in this directory; refresh aborted, core left untouched."
  notify "${MSG}" "PROBLEM ${TENANT}-${CORE} nightly solr refresh failed: ${CSVFILE} missing"
  exit 1
fi
ROWS=`wc -l < ${CSVFILE}`
if (( ${ROWS} < ${MINIMUM} )); then
   MSG="Only ${ROWS} rows in ${CSVFILE}; refresh aborted, core left untouched."
   notify "${MSG}" "PROBLEM with ${TENANT}-${CORE} nightly solr refresh: not enough rows"
   exit 1
else
   echo "${ROWS} rows in ${CSVFILE}: so we have the number (${MINIMUM}) to proceed. Full speed ahead."
fi
##############################################################################
# count the types and tokens in the final file, check cell counts
##############################################################################
time python3 ../common/evaluate.py 4solr.${TENANT}.${FILE_PART}.csv /dev/null > ${TENANT}.counts.${FILE_PART}.csv &
# zap the existing core, if the file we are loading is the CORE file.
# (we might be loading several into this core)
if [ "${FILE_PART}" == "${CORE}" ]; then
  echo "this file is 4solr.${TENANT}.${FILE_PART}.csv, ergo, we zap solr/${TENANT}-${CORE} first..."
  curl -S -s "http://localhost:8983/solr/${TENANT}-${CORE}/update" --data '<delete><query>*:*</query></delete>' -H 'Content-type:text/xml; charset=utf-8'
  curl -S -s "http://localhost:8983/solr/${TENANT}-${CORE}/update" --data '<commit/>' -H 'Content-type:text/xml; charset=utf-8'
else
  echo "POSTing 4solr.${TENANT}.${FILE_PART}.csv, i.e. adding documents to existing solr/${TENANT}-${CORE} ..."
fi
##############################################################################
# generate the field splitting parameters for the post to solr
##############################################################################
head -1 4solr.${TENANT}.${FILE_PART}.csv | sort | perl -pe 's/[\t\r]/\n/g' | perl -ne 'chomp; next unless /_(dt|s|i)s/; print "f.$_.split=true&f.$_.separator=%7C&"' > uploadparms.${TENANT}.${FILE_PART}.txt
ss_string=`cat uploadparms.${TENANT}.${FILE_PART}.txt`
SOLRCMD="http://localhost:8983/solr/${TENANT}-${CORE}/update/csv?commit=true&header=true&trim=true&separator=%09&${ss_string}&encapsulator=\\"
##############################################################################
# the heavy lifting starts...
##############################################################################
time curl -X POST -S -s "${SOLRCMD}" -H 'Content-type:text/plain; charset=utf-8' -T 4solr.${TENANT}.${FILE_PART}.csv
echo "time curl -X POST -S -s "${SOLRCMD}" -H 'Content-type:text/plain; charset=utf-8' -T 4solr.${TENANT}.${FILE_PART}.csv"
if [ $? != 0 ]; then
  MSG="Solr POST failed for ${TENANT}-${CORE}, file 4solr.${TENANT}.${FILE_PART}.csv ; retrying using previous successful upload"
  notify "${MSG}" "PROBLEM ${TENANT}-${CORE} nightly solr refresh failed"
  gunzip -k -f /tmp/4solr.${TENANT}.${FILE_PART}.csv.gz
  time curl -X POST -S -s "$SOLRCMD" -H 'Content-type:text/plain; charset=utf-8' -T /tmp/4solr.${TENANT}.${FILE_PART}.csv
  if [ $? =! 0 ]; then
    MSG="Solr re-POST failed for ${TENANT}-${CORE}, file 4solr.${TENANT}.${FILE_PART}.csv; giving up and sending email."
    notify "${MSG}" "PROBLEM ${TENANT}-${CORE} nightly solr refresh from previous saved file (2nd attempt), failed too"
  else
    MSG="Solr re-POST succeed for ${TENANT}-${CORE}, file 4solr.${TENANT}.${FILE_PART}.csv."
    notify "${MSG}" "PROBLEM ${TENANT}-${CORE} nightly solr refreshed from previous saved file."
  fi
  # remove the gunzipped copy we made, but leave the original gzipped file
  rm /tmp/4solr.${TENANT}.${FILE_PART}.csv
else
  ##############################################################################
  # the refresh succeeded.
  ##############################################################################
  # count rows, blobs, etc.
  ##############################################################################
  if [ ${BLOB_COLUMN} != 0 ]; then
    cut -f${BLOB_COLUMN} 4solr.${TENANT}.${FILE_PART}.csv | grep -v 'blob_ss' | perl -pe 's/\r//' |  grep . | wc -l > ${TENANT}.counts.${FILE_PART}.blobs.csv
    cut -f${BLOB_COLUMN} 4solr.${TENANT}.${FILE_PART}.csv | grep -v 'blob_ss' | perl -pe 's/\r//;s/,/\n/g;s/\|/\n/g;'| grep . | wc -l >> ${TENANT}.counts.${FILE_PART}.blobs.csv
    cp ${TENANT}.counts.${FILE_PART}.blobs.csv /tmp/
    cat ${TENANT}.counts.${FILE_PART}.blobs.csv
  fi
  cp ${TENANT}.counts.${FILE_PART}.csv /tmp/
  ##############################################################################
  # log the state of the .csv files
  ##############################################################################
  wc -l *.csv
  ##############################################################################
  # gzip and copy the successful extract to /tmp in case we need it tomorrow.
  # nb: we leave the file here in the runtime directory as well as in some
  # cases it is needed by other pipelines.
  # (first wait for any processes started earlier...)
  ##############################################################################
  wait
  gzip -f 4solr.${TENANT}.${FILE_PART}.csv
  mv 4solr.${TENANT}.${FILE_PART}.csv.gz /tmp
fi
mv *.csv /tmp
