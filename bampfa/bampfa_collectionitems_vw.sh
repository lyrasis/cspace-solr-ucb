#!/bin/bash -x
#
# script to extract data from the 'special BAMPFA view' and email it to those who need it.
#
date
source ${HOME}/pipeline-config.sh
TENANT=$1
cd ${HOME}/solrdatasources/${TENANT}
SERVER="${BAMPFA_SERVER}"
USERNAME="reporter_${TENANT}"
DATABASE="${TENANT}_domain_${TENANT}"
CONNECTSTRING="host=$SERVER dbname=$DATABASE sslmode=prefer"
CONTACT="${BAMPFA_CONTACT}"
##############################################################################
#
##############################################################################
time psql -R"@@" -A -U $USERNAME -d "$CONNECTSTRING"  -c "select * from utils.${TENANT}_collectionitems_vw" -o ${TENANT}_collectionitems_vw.tab
# some fix up required, alas: data from cspace is dirty: contain csv delimiters, newlines, etc. that's why we used @@ as temporary record separator
time perl -i -pe 's/[\r\n]/ /g;s/\@\@/\n/g;s/\|/\t/g;' ${TENANT}_collectionitems_vw.tab
rm -f ${TENANT}_collectionitems_vw.tab.gz
gzip ${TENANT}_collectionitems_vw.tab
mail -A ${TENANT}_collectionitems_vw.tab.gz -r "cspace-support@lists.berkeley.edu" -s "${TENANT}_collectionitems_vw.csv.gz" -- ${CONTACT} < /dev/null
#
date
