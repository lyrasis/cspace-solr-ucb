#!/bin/bash -x
#
##############################################################################
# shell script to extract osteology data from database and prep them for load
# into Solr4 using the "csv datahandler"
##############################################################################
date
cd /home/app_solr/solrdatasources/pahma
##############################################################################
# while most of this script is already tenant specific, many of the specific commands
# are shared between the different scripts; having them be as similar as possible
# eases maintainance. ergo, the TENANT parameter
##############################################################################
TENANT=$1
CORE=osteology
HOSTNAME="dba-postgres-prod-45.ist.berkeley.edu port=5307 sslmode=prefer"
USERNAME="reporter_pahma"
DATABASE="pahma_domain_pahma"
CONNECTSTRING="host=$HOSTNAME dbname=$DATABASE"
##############################################################################
# extract media info from CSpace
##############################################################################
time psql -F $'\t' -R"@@" -A -U $USERNAME -d "$CONNECTSTRING" -f osteology.sql -o o1.csv
# cleanup newlines and crlf in data, then switch record separator.
time perl -i -pe 's/[\r\n]/ /g;s/\@\@/\n/g' o1.csv
##############################################################################
# we want to recover and use our "special" solr-friendly header, which got buried
##############################################################################
gunzip 4solr.${TENANT}.internal.csv.gz
# compress the osteology data into a single variable
python3 osteology_analyzer.py o1.csv o2.csv
sort o2.csv > o3.csv
# add the internal data
python3 join.py o3.csv 4solr.${TENANT}.internal.csv > o4.csv
# csid_s is both files, let's keep only one in this file
cut -f1,3- o4.csv > o5.csv
grep -P "^id\t" o5.csv > header4Solr.csv
grep -v -P "^id\t" o5.csv > o6.csv
cat header4Solr.csv o6.csv > o7.csv
##############################################################################
# count the types and tokens in the final file
##############################################################################
time python3 evaluate.py o7.csv 4solr.${TENANT}.osteology.csv > counts.osteology.csv
##############################################################################
# check if we have enough data to be worth refreshing...
##############################################################################
CSVFILE="4solr.${TENANT}.${CORE}.csv"
# this value is an approximate lower bound on the number of rows there should
# be, based on data as of 2019-09-11. It may need to be periodically adjusted.
MINIMUM=15000
ROWS=`wc -l < ${CSVFILE}`
if (( ${ROWS} < ${MINIMUM} )); then
   echo "Only ${ROWS} rows in ${CSVFILE}; refresh aborted, core left untouched." | mail -s "PROBLEM with ${TENANT}-${CORE} nightly solr refresh" -- cspace-support@lists.berkeley.edu
   exit 1
fi
##############################################################################
# OK, we are good to go! clear out the existing data
##############################################################################
curl -S -s "http://localhost:8983/solr/${TENANT}-${CORE}/update" --data '<delete><query>*:*</query></delete>' -H 'Content-type:text/xml; charset=utf-8'
curl -S -s "http://localhost:8983/solr/${TENANT}-${CORE}/update" --data '<commit/>' -H 'Content-type:text/xml; charset=utf-8'
##############################################################################
# this POSTs the csv to the Solr / update endpoint
# note, among other things, the overriding of the encapsulator with \
##############################################################################
head -1 4solr.${TENANT}.${CORE}.csv | perl -pe 's/[\t\r]/\n/g' | perl -ne 'chomp; next unless /_(dt|s|i)s/; print "f.$_.split=true&f.$_.separator=%7C&"' > uploadparms.${CORE}.txt
ss_string=`cat uploadparms.${CORE}.txt`
time curl -X POST -S -s "http://localhost:8983/solr/${TENANT}-${CORE}/update/csv?commit=true&header=true&separator=%09&${ss_string}f.blob_ss.split=true&f.blob_ss.separator=,&encapsulator=\\" -T 4solr.${TENANT}.${CORE}.csv -H 'Content-type:text/plain; charset=utf-8' &
rm o?.csv header4Solr.csv
# count blobs
cut -f78 4solr.${TENANT}.osteology.csv | grep -v 'blob_ss' |perl -pe 's/\r//' |  grep . | wc -l > counts.osteology.blobs.csv
cut -f78 4solr.${TENANT}.osteology.csv | perl -pe 's/\r//;s/,/\n/g;s/\|/\n/g;' | grep -v 'blob_ss' | grep . | wc -l >> counts.osteology.blobs.csv &
wait
cp counts.osteology.blobs.csv /tmp/${TENANT}.counts.osteology.blobs.csv
cat counts.osteology.blobs.csv
cp counts.osteology.csv /tmp/${TENANT}.counts.osteology.csv
gzip -f 4solr.${TENANT}.osteology.csv &
gzip -f 4solr.${TENANT}.internal.csv &
wait
date
