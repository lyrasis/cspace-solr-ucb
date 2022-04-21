#
# fragile script to regenerate the cache (pickle) of GBIF parsed name parts
#
# invoke as: ./generate.sh
#
# if you want to regenerate the cache from scratch, proceed as follows
#
cd ${HOME}/solrdatasources/botgarden/gbif
cp ${SOLR_CACHE_DIR}/4solr.botgarden.public.csv.gz .
gunzip 4solr.botgarden.public.csv.gz
# just to be clear: we are reparsing the determination field from the previous night's extract
cut -f17 4solr.botgarden.public.csv > scinames.csv
# this version of the script is a bit rude: it hits GBIF sequentially, but without pauses
python3 parseNamesGBIFparts.py scinames.csv parsednames.csv names.pickle
# nohup python /usr/local/share/django/botgarden_project/gbif/parseNamesGBIF4UCBG.py scinames.csv parsednames.csv names.pickle &
# python /usr/local/share/django/botgarden_project/gbif/parseNamesGBIF4UCBG.py scinames.csv parsednames.csv names.pickle
rm 4solr.botgarden.public.csv
# make a copy, in case we need to recover it
cp names.pickle ${SOLR_CACHE_DIR}
