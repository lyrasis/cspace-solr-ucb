#!/bin/bash -x
date
##############################################################################
# while most of this script is already tenant specific, many of the specific commands
# are shared between the different scripts; having them be as similar as possible
# eases maintainance. ergo, the TENANT parameter
##############################################################################
source pipeline-config.sh
TENANT=$1
##############################################################################
CORE=internal
CONTACT="${BOTGARDEN_CONTACT}"
cd ${HOME}/solrdatasources/${TENANT}
##############################################################################
# up to here, both public and internal extracts are the same.
# so we use the public metadata and media file and carry on
gunzip 4solr.${TENANT}.media.csv.gz
gunzip public.metadata.csv.gz
gunzip header4Solr.csv.gz
##############################################################################
# add the blob csids
##############################################################################
time perl mergeObjectsAndMedia.pl 4solr.${TENANT}.media.csv public.metadata.csv ${CORE} > d9.csv
# uses the header created by the public pipeline. it better be available!
cat header4Solr.csv d9.csv | perl -pe 's/␥/|/g' > d10.csv
##############################################################################
# compute _i values for _dt values (to support BL date range searching)
##############################################################################
time python3 computeTimeIntegers.py d10.csv 4solr.${TENANT}.${CORE}.csv
# shorten this one long org name...
perl -i -pe 's/International Union for Conservation of Nature and Natural Resources/IUCN/g' 4solr.${TENANT}.${CORE}.csv
##############################################################################
# get rid of intermediate files
##############################################################################
rm -f d?.csv d??.csv m?.csv metadata*.csv header4Solr.csv
##############################################################################
# OK, we are good to go! clear out the existing data and reload
##############################################################################
../common/post_to_solr.sh ${TENANT} ${CORE} ${CONTACT}  50000 74
date
