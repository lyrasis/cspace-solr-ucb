#!/bin/bash -x
date
##############################################################################
# while most of this script is already tenant specific, many of the specific commands
# are shared between the different scripts; having them be as similar as possible
# eases maintainance. ergo, the TENANT parameter
##############################################################################
source pipeline-config.sh
TENANT=$1
CORE=public
SERVER="${UCJEPS_SERVER}"
USERNAME="reporter_${TENANT}"
DATABASE="${TENANT}_domain_${TENANT}"
CONNECTSTRING="host=$SERVER dbname=$DATABASE sslmode=prefer"
CONTACT="${UCJEPS_CONTACT}"
##############################################################################
cd ${HOME}/solrdatasources/${TENANT}
##############################################################################
# extract and massage the metadata from CSpace
##############################################################################
time psql -F $'\t' -R"@@" -A -U $USERNAME -d "$CONNECTSTRING" -f ucjepsMetadata.sql -o d1.csv
time perl -pe 's/[\r\n]/ /g;s/\@\@/\n/g' d1.csv | perl -ne 'next if / rows/; print $_' > d3.csv
##############################################################################
# count the types and tokens in the sql output, check cell counts
##############################################################################
time python3 ../common/evaluate.py d3.csv metadata.csv > ${TENANT}.counts.${CORE}.rawdata.csv
##############################################################################
# get media
##############################################################################
time psql -F $'\t' -R"@@" -A -U $USERNAME -d "$CONNECTSTRING" -f ucjepsMedia.sql -o media.csv
time perl -i -pe 's/[\r\n]/ /g;s/\@\@/\n/g' media.csv
##############################################################################
# make a unique sequence number for id
##############################################################################
time perl -i -pe '$i++;print $i . "\t"' metadata.csv
##############################################################################
# add the blobcsids to mix
##############################################################################
time perl mergeObjectsAndMedia.pl media.csv metadata.csv > d6.csv
##############################################################################
# make sure dates are in ISO-8601 format. Solr accepts nothing else!
##############################################################################
tail -n +2 d6.csv | perl fixdate.pl > d7.csv
##############################################################################
# check latlongs
##############################################################################
time perl -ne '@x=split /\t/;print if abs($x[22])<90 && abs($x[23])<180;' d7.csv > d8.csv
time perl -ne '@x=split /\t/;print if !(abs($x[22])<90 && abs($x[23])<180);' d7.csv > ${TENANT}.counts.errors_in_latlong.csv
##############################################################################
# snag UCBG accession number and stuff it in the right field
##############################################################################
time perl -i -ne '@x=split /\t/;$x[52]="";($x[51]=~/U.?C.? Botanical Ga?r?de?n.*(\d\d+\.\d+)|(\d+\.\d+).*U.?C.? Botanical Ga?r?de?n/)&&($x[49]="$1$2");print join "\t",@x;' d8.csv
##############################################################################
# parse collector names
##############################################################################
time perl -i -ne '@x=split /\t/;$_=$x[8];unless (/Paccard/ || (!/ [^ ]+ [^ ]+ [^ ]+/ && ! /,.*,/ && ! / (and|with|\&) /)) {s/,? (and|with|\&) /|/g;s/, /|/g;s/,? ?\[(in company|with) ?(.*?)\]/|\2/;s/\|Jr/, Jr/g;s/\|?et al\.?//;s/\|\|/|/g;};s/ \& /|/ if /Paccard/;$x[8]=$_;print join "\t",@x;' d8.csv
##############################################################################
# recover & use our "special" solr-friendly header, which got buried
# and name the first column 'id'; add the blob field name to the header.
##############################################################################
head -1 metadata.csv | perl -i -pe 's/\r//;s/^1\t/id\t/;s/$/\tblob_ss/;s/\r//g'> header4Solr.csv
grep -v csid_s d8.csv > d9.csv
cat header4Solr.csv d9.csv | perl -pe 's/␥/|/g' > 4solr.${TENANT}.${CORE}.csv
# clean up some stray quotes. Really this should get fixed properly someday!
perl -i -pe 's/\\/\//g;s/\t"/\t/g;s/"\t/\t/g;s/\"\"/"/g' 4solr.${TENANT}.${CORE}.csv
##############################################################################
# mark duplicate accession numbers
# nb: no longer needed, but code retained below for posterity
##############################################################################
# cut -f3 4solr.${TENANT}.${CORE}.csv | sort | uniq -c | sort -rn |perl -ne 'print unless / 1 / ' > ${TENANT}.counts.duplicates.csv
# cut -c9- ${TENANT}.counts.duplicates.csv | perl -ne 'chomp; print "s/\\t$_\\t/\\t$_ (duplicate)\\t/;\n"' > fix_dups.sh
# time perl -i -p fix_dups.sh 4solr.${TENANT}.${CORE}.csv
##############################################################################
# OK, we are good to go! clear out the existing data and reload
##############################################################################
# send the errors off to be dealt with
tar -czf counts.tgz ${TENANT}.counts.*.csv
./make_error_report.sh | mail -A counts.tgz -s "UCJEPS Solr Refresh Counts and Errors `date`" ${CONTACT}
# get rid of intermediate files
rm d?.csv metadata.csv media.csv
# first hide these two files so zapCoords.sh can find and use them
gzip ucjeps.counts.errors_in_latlong.csv
gzip header4Solr.csv
../common/post_to_solr.sh ${TENANT} ${CORE} ${CONTACT}  900000 67
##############################################################################
# hack to zap latlong errors and load the records anyway.
# TODO: get rid of this somehow someday!
##############################################################################
gunzip ucjeps.counts.errors_in_latlong.csv.gz
gunzip header4Solr.csv.gz
./zapCoords.sh
rm header4Solr.csv
mv counts.tgz /var/solr/tmp/ucjeps.counts.tgz
mv ucjeps.counts.errors_in_latlong.csv /var/solr/tmp
# moving .csv files and saving the extract is done in post_to_solr!
date
