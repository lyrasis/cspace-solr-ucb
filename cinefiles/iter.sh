rm nohup.out 
nohup ./solrETL-public.sh cinefiles 
gunzip *.csv.gz
head -100 counts.*.csv
