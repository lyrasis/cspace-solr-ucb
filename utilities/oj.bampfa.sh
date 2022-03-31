#!/usr/bin/env bash

${HOME}/solrdatasources/bampfa/solrETL-public.sh           bampfa    2>&1 | /usr/bin/ts '[%Y-%m-%d %H:%M:%S]' >> ${HOME}/logs/bampfa.solr_extract_public.log  2>&1
${HOME}/solrdatasources/bampfa/solrETL-internal.sh         bampfa    2>&1 | /usr/bin/ts '[%Y-%m-%d %H:%M:%S]' >> ${HOME}/logs/bampfa.solr_extract_internal.log  2>&1
${HOME}/solrdatasources/bampfa/bampfa_collectionitems_vw.sh bampfa   2>&1 | /usr/bin/ts '[%Y-%m-%d %H:%M:%S]' >> ${HOME}/logs/bampfa.solr_extract_BAM.log  2>&1
# piction stuff no longer runs here. leaving these lines here only for future reference.
# ${HOME}/solrdatasources/bampfa/piction_extract.sh          bampfa    2>&1 | /usr/bin/ts '[%Y-%m-%d %H:%M:%S]' >> ${HOME}/logs/bampfa.solr_extract_Piction.log  2>&1
# we're no longer provisioning the bampfa site using this extract... dunno how it is happening!
# ${HOME}/solrdatasources/bampfa_website_extract.sh          bampfa    2>&1 | /usr/bin/ts '[%Y-%m-%d %H:%M:%S]' >> ${HOME}/logs/bampfa_website_extract.log 2>&1
