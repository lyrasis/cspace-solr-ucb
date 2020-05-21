#!/usr/bin/env bash

/home/app_solr/solrdatasources/ucjeps/solrETL-media.sh            ucjeps    2>&1 | /usr/bin/ts '[%Y-%m-%d %H:%M:%S]' >> /home/app_solr/logs/ucjeps.solr_extract_media.log  2>&1
/home/app_solr/solrdatasources/ucjeps/solrETL-public.sh           ucjeps    2>&1 | /usr/bin/ts '[%Y-%m-%d %H:%M:%S]' >> /home/app_solr/logs/ucjeps.solr_extract_public.log  2>&1
