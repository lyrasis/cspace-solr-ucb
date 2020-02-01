#!/bin/bash -x
date
cd /home/app_solr/solrdatasources/cinefiles
##############################################################################
# move the current set of extracts to temp (thereby saving the previous run, just in case)
# note that in the case where there are several nightly scripts, e.g. public and internal,
# the one to run first will "clear out" the previous night's data.
# NB: at the moment CineFiles has only a public solr core.
##############################################################################
mv 4solr.*.csv.gz /tmp
##############################################################################
# while most of this script is already tenant specific, many of the commands
# are shared between the different scripts; having them be as similar as possible
# eases maintainance. ergo, the TENANT parameter
##############################################################################
TENANT=$1
CORE=public
SERVER="dba-postgres-prod-42.ist.berkeley.edu port=5313 sslmode=prefer"
USERNAME="reporter_${TENANT}"
DATABASE="${TENANT}_domain_${TENANT}"
CONNECTSTRING="host=$SERVER dbname=$DATABASE"
CONTACT="cspace-support@lists.berkeley.edu"
##############################################################################
# extract metadata and media info from CSpace
##############################################################################
# NB: unlike the other ETL processes, we're still using the default | delimiter here
##############################################################################
time psql -R"@@" -F $'\t' -A -U $USERNAME -d "$CONNECTSTRING" --pset footer -c "select * from cinefiles_denorm.doclist_view"  -o d1a.csv
time psql -R"@@" -F $'\t' -A -U $USERNAME -d "$CONNECTSTRING" --pset footer -c "select * from cinefiles_denorm.filmlist_view" -o d1b.csv
time psql -R"@@" -F $'\t' -A -U $USERNAME -d "$CONNECTSTRING" --pset footer -c "select * from cinefiles_denorm.filmdocs" -o d1c.csv
time psql -R"@@" -F $'\t' -A -U $USERNAME -d "$CONNECTSTRING" --pset footer -f metadata_public.sql -o d1d.csv
# some fix up required, alas: data from cspace is dirty: contain csv delimiters, newlines, etc. that's why we used @@ as temporary record separator
time perl -pe 's/[\r\n]/ /g;s/\@\@/\n/g' d1a.csv > docs.csv
time perl -pe 's/[\r\n]/ /g;s/\@\@/\n/g' d1b.csv > films.csv
time perl -pe 's/[\r\n]/ /g;s/\@\@/\n/g' d1c.csv > link.csv
time perl -pe 's/[\r\n]/ /g;s/\@\@/\n/g' d1d.csv > metadata.csv
rm d1?.csv
time psql -R"@@" -F $'\t' --pset footer -A -U $USERNAME -d "$CONNECTSTRING" -f media_public.sql -o m1.csv
time perl -pe 's/[\r\n]/ /g;s/\@\@/\n/g' m1.csv > 4solr.${TENANT}.media.csv
time python3 evaluate.py 4solr.${TENANT}.media.csv /dev/null > counts.media.csv &

# special cases
cut -f1,25 metadata.csv > csids+docids.csv
cut -f1,5,8,14,15 4solr.${TENANT}.media.csv > csids+media_info.csv
cut -f1,2 link.csv > 4solr.${TENANT}.link.csv
perl -i -pe 's/updatedat/film_updatedat/;s/name_id/film_name_id/;' films.csv

# merge the documents, film, media (image and pdf) via the 2 "link" files
time python3 mergeObjectsAndMediaCineFiles.py 4solr.${TENANT}.media.csv link.csv csids+docids.csv films.csv docs.csv public.csv

for file in docs films metadata public
do
    # make the header
    head -1 ${file}.csv > header4Solr.csv
    # special cases (nb: some tricky regexes in here, caveat lector!)
    perl -i -pe 's/\r//;s/\t/_s\t/g;s/$/_s/;s/_ss_s/_ss/g;s/updatedat_s/updated_at_dt/g' header4Solr.csv
    perl -i -pe 's/has_s/has_ss/;s/filmyear_s/filmyear_ss/;s/film_info_s/film_info_ss/;s/director_s/director_ss/;s/prodco(.*?)_s/prodco\1_ss/g;s/subject_s/subject_ss/g;s/genre_s/genre_ss/;s/title_s/title_ss/g;s/language_s/language_ss/g;s/country_s/country_ss/;s/name_id_s/name_id_ss/;s/author_s/author_ss/;' header4Solr.csv
    #perl -i -pe 's/\r//;s/^/d/;s/\t/_s\t/g;s/ddoc_id_s/id/;s/$/_s\tblob_ss/;s/_ss_s/_ss/;' header4Solr.csv
    # we want to use our "special" solr-friendly header.
    tail -n +2 ${file}.csv | grep -v " rows)" > d7.csv
    cat header4Solr.csv d7.csv > 4solr.${TENANT}.${file}.csv
    perl -pe 's/\t/\n/g' header4Solr.csv | perl -ne 'chomp; next unless /_ss/; next if /blob/; print "f.$_.split=true&f.$_.separator=%7C&"' > uploadparms.${file}.txt
    cat header4Solr.csv
done

wc -l *.csv
##############################################################################
# check if we have enough data to be worth refreshing...
##############################################################################
CSVFILE="4solr.${TENANT}.${CORE}.csv"
# this value is an approximate lower bound on the number of rows there should
# be, based on data as of 2019-09-11. It may need to be periodically adjusted.
MINIMUM=50000
ROWS=`wc -l < ${CSVFILE}`
if (( ${ROWS} < ${MINIMUM} )); then
   echo "Only ${ROWS} rows in ${CSVFILE}; refresh aborted, core left untouched." | mail -s "PROBLEM with ${TENANT}-${CORE} nightly solr refresh" -- cspace-support@lists.berkeley.edu
fi

##############################################################################
# OK, we are good to go! clear out the existing data
##############################################################################
curl -S -s "http://localhost:8983/solr/${TENANT}-${CORE}/update" --data '<delete><query>*:*</query></delete>' -H 'Content-type:text/xml; charset=utf-8'
curl -S -s "http://localhost:8983/solr/${TENANT}-${CORE}/update" --data '<commit/>' -H 'Content-type:text/xml; charset=utf-8'

#for file in films docs
for file in public
do

    ss_string=`cat uploadparms.${file}.txt`
    time curl -X POST -S -s "http://localhost:8983/solr/${TENANT}-${CORE}/update/csv?commit=true&header=true&trim=true&separator=%09&${ss_string}f.grouptitle_ss.split=true&f.grouptitle_ss.separator=;&f.othernumbers_ss.split=true&f.othernumbers_ss.separator=;&f.blob_ss.split=true&f.blob_ss.separator=,&encapsulator=\\" -T 4solr.${TENANT}.${file}.csv -H 'Content-type:text/plain; charset=utf-8' &
    time python3 evaluate.py 4solr.${TENANT}.${file}.csv /dev/null > counts.${file}.csv &
done

# get rid of intermediate files
# count blobs
cut -f51 4solr.${TENANT}.${CORE}.csv | grep -v 'blob_ss' |perl -pe 's/\r//' |  grep . | wc -l > counts.${CORE}.blobs.csv
cut -f51 4solr.${TENANT}.${CORE}.csv | perl -pe 's/\r//;s/,/\n/g;s/\|/\n/g;' | grep -v 'blob_ss' | grep . | wc -l >> counts.${CORE}.blobs.csv &
wait
cp counts.${CORE}.blobs.csv /tmp/${TENANT}.counts.${CORE}.blobs.csv
# rm d?.csv m?.csv b?.csv media.csv docs.csv films.csv header4Solr.csv
rm d?.csv m?.csv b?.csv header4Solr.csv
cat counts.${CORE}.blobs.csv
# zip up .csvs, save a bit of space on backups
gzip -f *.csv
#
date
