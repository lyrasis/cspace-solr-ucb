#!/usr/bin/env bash

# single argument: a list of PAHMA museum numbers, one per line
if [ $# -ne 1 ]; then
    echo "usage: $0 list_of_museum_numbers_to_check.txt"
    exit
fi


python tS.py pahma-public http://localhost:8983 'objmusno_txt:"%s"' < $1 > objmusno_txt.txt &
python tS.py pahma-public http://localhost:8983 'objmusno_s:"%s"' < $1 > objmusno_s.txt &
perl -pe 'tr/A-Z/a-z/' $1 | python tS.py pahma-public http://localhost:8983 'objmusno_s:"%s"' > objmusno_s_vs_lower.txt &
perl -pe 'tr/A-Z/a-z/' $1 | python tS.py pahma-public http://localhost:8983 'objmusno_s_lower:"%s"' > objmusno_s_lower.txt &

wait

echo "frequency distribution of queries and number of results"
echo
echo "e.g. if there are 100 queries, and all return a single result (which should be the case for museum numbers)"
echo "the output, at least for the 'lower case' result, should be '100   1'."
echo
for x in s_lower s_vs_lower s txt
do
    echo
    echo "objmusno_${x}.txt"
    echo "number of queries  number results"
    echo "=================  =============="
    cut -f2 objmusno_${x}.txt | sort -n | uniq -c | head -20 | perl -pe 's/(\d+) (\d+)/\1                 \2/'
done
