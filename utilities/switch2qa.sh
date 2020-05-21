#!/usr/bin/env bash
#
# a lil script to change the solr pipelines to point to qa instead of prod and to
# send email notifications to jblowe and not the various "real" addresses.
cd
perl -i -pe 's/prod-42.ist.berkeley.edu/dev-45.ist.berkeley.edu/' solrdatasources/*/*.sh
perl -i -pe 's/=5313/=5113/' solrdatasources/*/*.sh
perl -i -pe 's/=5307/=5107/' solrdatasources/*/*.sh
perl -i -pe 's/=5310/=5110/' solrdatasources/*/*.sh
perl -i -pe 's/cspace.support.lists./jblowe@/' solrdatasources/*/*.sh
perl -i -pe 's/CONTACT=.*/CONTACT="jblowe\@berkeley.edu"/' solrdatasources/*/*.sh
