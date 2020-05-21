#!/usr/bin/env bash

/home/app_solr/solrdatasources/botgarden/solrETL-public.sh        botgarden 2>&1 | /usr/bin/ts '[%Y-%m-%d %H:%M:%S]' >> /home/app_solr/logs/botgarden.solr_extract_public.log  2>&1
/home/app_solr/solrdatasources/botgarden/solrETL-internal.sh      botgarden 2>&1 | /usr/bin/ts '[%Y-%m-%d %H:%M:%S]' >> /home/app_solr/logs/botgarden.solr_extract_internal.log  2>&1
/home/app_solr/solrdatasources/botgarden/solrETL-propagations.sh  botgarden 2>&1 | /usr/bin/ts '[%Y-%m-%d %H:%M:%S]' >> /home/app_solr/logs/botgarden.solr_extract_propagations.log  2>&1
