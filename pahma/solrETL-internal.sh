#!/bin/bash -x
#
##############################################################################
# this script loads the solr core for the "internal" portal.
#
# the input file is created by the script that creates the input file for
# the public core, so all this script has to do is unzip it and POST it to
# to the Solr update endpoint...
#
# Features of the 'internal' metadata, so far:
#
# un-obfuscated latlongs
# all images, "in the clear", including catalog cards
# museum location info
#
##############################################################################
date
cd /home/app_solr/solrdatasources/pahma
##############################################################################
# note that there are 4 nightly scripts, public, internal, and locations,
# and osteology.
# the scripts need to run in order: public > internal > locations | osteology.
# internal (this script) depends on data created by public
# while most of this script is already tenant specific, many of the specific commands
# are shared between the different scripts; having them be as similar as possible
# eases maintenance. ergo, the TENANT parameter
##############################################################################
TENANT=$1
CORE=internal
CONTACT="mtblack@berkeley.edu"
##############################################################################
# we use the csv file for the internal store, prepared by the solrETL-public.sh
##############################################################################
../common/post_to_solr.sh ${TENANT} ${CORE} ${CONTACT} 760000 59
# no cleanup done here!
date
