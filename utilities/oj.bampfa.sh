#!/usr/bin/env bash

/home/app_solr/solrdatasources/bampfa/solrETL-public.sh           bampfa    2>&1 | /usr/bin/ts '[%Y-%m-%d %H:%M:%S]' >> /home/app_solr/logs/bampfa.solr_extract_public.log  2>&1
/home/app_solr/solrdatasources/bampfa/solrETL-internal.sh         bampfa    2>&1 | /usr/bin/ts '[%Y-%m-%d %H:%M:%S]' >> /home/app_solr/logs/bampfa.solr_extract_internal.log  2>&1
/home/app_solr/solrdatasources/bampfa/bampfa_collectionitems_vw.sh bampfa   2>&1 | /usr/bin/ts '[%Y-%m-%d %H:%M:%S]' >> /home/app_solr/logs/bampfa.solr_extract_BAM.log  2>&1
# piction stuff no longer runs here. leaving these lines here only for future reference.
# /home/app_solr/solrdatasources/bampfa/piction_extract.sh          bampfa    2>&1 | /usr/bin/ts '[%Y-%m-%d %H:%M:%S]' >> /home/app_solr/logs/bampfa.solr_extract_Piction.log  2>&1
# we're no longer provisioning the bampfa site using this extract... dunno how it is happening!
# /home/app_solr/solrdatasources/bampfa_website_extract.sh          bampfa    2>&1 | /usr/bin/ts '[%Y-%m-%d %H:%M:%S]' >> /home/app_solr/logs/bampfa_website_extract.log 2>&1
