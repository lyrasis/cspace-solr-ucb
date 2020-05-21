#!/usr/bin/env bash

# run the 'legacy denormalizing' script first, to populate the 'cinefiles_denorm' db schema used by the portal
cd /home/app_solr/solrdatasources/cinefiles ; /bin/bash -l -c './cinefiles_denorm_nightly.sh' ; cd
# now run the regular pipeline that populates solr
/home/app_solr/solrdatasources/cinefiles/solrETL-public.sh        cinefiles 2>&1 | /usr/bin/ts '[%Y-%m-%d %H:%M:%S]' >> /home/app_solr/logs/cinefiles.solr_extract_public.log  2>&1
