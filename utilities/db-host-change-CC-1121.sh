#
# a lil script to change the solr ppipelines to point to the new db server
# should work for prod, dev, and qa
perl -i -pe 's/prod-45.ist.berkeley.edu/prod-45.ist.berkeley.edu/' solrdatasources/*/*.sh
perl -i -pe 's/dev-42.ist.berkeley.edu/dev-45.ist.berkeley.edu/' solrdatasources/*/*.sh
