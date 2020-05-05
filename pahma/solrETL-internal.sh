#!/bin/bash -x
#
##############################################################################
# this script loads the solr core for the "internal" portal.
#
# the input file is created by the script that creates the input file for
# the public core, so all this script has to do is unzip it and POST it to
# to the Solr update endpoint...
#
# Features of the 'internal' metadata, so far:
#
# un-obfuscated latlongs
# all images, "in the clear", including catalog cards
# museum location info
#
##############################################################################
date
cd /home/app_solr/solrdatasources/pahma
##############################################################################
# note that there are 4 nightly scripts, public, internal, and locations,
# and osteology.
# the scripts need to run in order: public > internal > locations | osteology.
# internal (this script) depends on data created by public
# so in this case, the internal script cannot 'stash' any files...they
# have already been stashed by the public script, and this script needs one
# of them.
# while most of this script is already tenant specific, many of the specific commands
# are shared between the different scripts; having them be as similar as possible
# eases maintenance. ergo, the TENANT parameter
##############################################################################
TENANT=$1
CORE=internal
##############################################################################
# gunzip the csv file for the internal store, prepared by the solrETL-public.sh
##############################################################################
gunzip -f 4solr.${TENANT}.${CORE}.csv.gz
##############################################################################
# check if we have enough data to be worth refreshing...
##############################################################################
CSVFILE="4solr.${TENANT}.${CORE}.csv"
# this value is an approximate lower bound on the number of rows there should
# be, based on data as of 2019-09-11. It may need to be periodically adjusted.
MINIMUM=750000
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
##############################################################################
# wrap things up: make a gzipped version of what was loaded
##############################################################################
# count blobs
cut -f59 4solr.${TENANT}.${CORE}.csv | grep -v 'blob_ss' |perl -pe 's/\r//' |  grep . | wc -l > counts.${CORE}.blobs.csv
cut -f59 4solr.${TENANT}.${CORE}.csv | perl -pe 's/\r//;s/,/\n/g;s/\|/\n/g;' | grep -v 'blob_ss' | grep . | wc -l >> counts.${CORE}.blobs.csv
wait
cp counts.${CORE}.blobs.csv /tmp/${TENANT}.counts.${CORE}.blobs.csv
cat counts.${CORE}.blobs.csv
gzip -f 4solr.*.csv
date
