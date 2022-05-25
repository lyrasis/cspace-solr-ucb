#!/usr/bin/env bash

source ${HOME}/pipeline-config.sh

# run the 'legacy denormalizing' script first, to populate the 'cinefiles_denorm' db schema used by the portal
cd ${HOME}/solrdatasources/cinefiles ; /bin/bash -l -c './cinefiles_denorm_nightly.sh' | /usr/bin/ts '[%Y-%m-%d %H:%M:%S]' >> ${SOLR_LOG_DIR}/cinefiles.solr_extract_public.log  2>&1 ; cd
# now run the regular ppipeline that populates solr
${HOME}/solrdatasources/cinefiles/solrETL-public.sh        cinefiles 2>&1 | /usr/bin/ts '[%Y-%m-%d %H:%M:%S]' >> ${SOLR_LOG_DIR}/cinefiles.solr_extract_public.log  2>&1
