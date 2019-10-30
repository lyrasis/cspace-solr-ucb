#### ETL to extract data for Solr datastores

This directory contains the components of the Solr4 system supporting
the CSpace "Portals"

There is one directory per UCB tenant, each directory contains the SQL and other
magic to refresh that tenant's Solr cores.

The instructions to install Solr and configure the cores is not here; look in the
cspace_django_project directory for that code. HOWEVER, the ucb/ directory here DOES
contain schema, etc. to configure solar to accept the .csv format files extracted via psql...

There is also a ```utilities``` directory containing directions and code for setting
the ETL scripts to run nightly via cron.

The crontab for the app_solr pseudo-user is now one line:

```bash
[app_solr@cspace-prod-01 ~]$ crontab -l
01 3 * * * /home/app_solr/one_job.sh >> /home/app_solr/refresh.log
```

This runs each museum refresh (which may have several cores) as a separate job ("oj.*.sh"), but
starts them at the same time (so the museums are refreshing in parallel).

The rationale for running all the solr refreshes (and some other processes) as a single script
is that it minimizes the total elapsed time and eliminates any chance of the jobs overlapping.

NB: as of November 2019, the 13 refreshes take about 3 hours to run sequentially.

tS.py is a short script to test the (local) installation of the Python solr
client module and operation of the (local) solr server. To run:

```bash
$ python tS.py pahma-public
pahma-public, records found: 735314
```

(NB: solr must be running on localhost:8983 and have a core with the specified name)

Other contents of the app_solr working directory (which includes the content of this
GitHub directory):

archive - junk. anything that might be needed for debugging or other purposes.
checkstatus.sh - a script to display the contents of the UCB solr4 portals
                 and the status of the last refresh jobs.
one_job.sh - script to run all solr refresh and other extract processes.
optimize.log - output of optimize.sh (overwritten each time).
optimize.sh - runs the "optimize" process on each solr core. Not strictly
              necessary, but solr performs better.
solrdatasources - the ETL code (i.e. nightly scripts) to refresh the Portals.
solr4 - the UCB solr4 cores.
cspace-solr-ucb - clone of the Tools repo. Needed for updates.
README - this file.
refresh.log - cumulative log of refreshes.

#### How to deploy the Solr ETL scripts

```bash
# the following steps will setup the solr etl for UCB in ~app_solr.
# note there is a step to change the set to point to Dev instead of Prod.
#
# NB: this is not really a script though it looks like one, and indeed
#     everything except the crontab and .pgpass setup could be run as such
#     But you'd be advised to do each step yourself and make sure
#     it works.
#
#     also note that this just deploys the ETL code on a managed server.
#     it presumes that you have already installed and started Solr, and have
#     configured the appropriate cores.
#
#     finally, if you run these steps on Prod, you'll blow away the logs
#     that have been created by past runs. Perhaps you don't care, but
#     if you do, you should take care to just copy the needed files and leave
#     logs.
#
# To deploy from scratch:
#
cd ~/cspace-solr-ucb/
git pull -v
# checkout the release tag, if desired
git checkout X.Y.Z
cd ~
rm -rf ~/solrdatasources
cp -r ~/cspace-solr-ucb/ ~/solrdatasources
cd ~/solrdatasources/
# "ucb" is the solr server configuration -- there is a different process
# to set that up and get a solr server running.
rm -rf ucb
# optional: point to dev
perl -i -pe 's#prod\-42.ist.berkeley.edu port=53#dev-42.ist.berkeley.edu port=51#' */*.sh
# you will want to sent up the cron job to run one_job.sh
cat ~/cspace-solr-ucb/utilities/crontab.app_solr
crontab -e
# check that .pgpass is set up correctly
cat ~/.pgpass
#
# To simply update the ETL code for a single tenant, providing that the updated code is
# in GitHub already:
#
cd ~/cspace-solr-ucb
git pull -v
cp -r pahma/* ~/solrdatasources/pahma
# if this is a Dev deployment, update the files to point to dev
cd ~/solrdatasources/pahma
perl -i -pe 's#prod\-42.ist.berkeley.edu port=53#dev-42.ist.berkeley.edu port=51#' */*.sh
```
