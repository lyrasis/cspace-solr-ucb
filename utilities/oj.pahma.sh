#!/usr/bin/env bash

/home/app_solr/solrdatasources/pahma/solrETL-public.sh            pahma     2>&1 | /usr/bin/ts '[%Y-%m-%d %H:%M:%S]' >> /home/app_solr/logs/pahma.solr_extract_public.log  2>&1
/home/app_solr/solrdatasources/pahma/solrETL-internal.sh          pahma     2>&1 | /usr/bin/ts '[%Y-%m-%d %H:%M:%S]' >> /home/app_solr/logs/pahma.solr_extract_internal.log  2>&1
/home/app_solr/solrdatasources/pahma/solrETL-locations.sh         pahma     2>&1 | /usr/bin/ts '[%Y-%m-%d %H:%M:%S]' >> /home/app_solr/logs/pahma.solr_extract_locations.log  2>&1
/home/app_solr/solrdatasources/pahma/solrETL-osteology.sh         pahma     2>&1 | /usr/bin/ts '[%Y-%m-%d %H:%M:%S]' >> /home/app_solr/logs/pahma.solr_extract_osteology.log  2>&1
