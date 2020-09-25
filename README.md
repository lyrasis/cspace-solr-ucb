### ETL to extract data for Solr datastores

This directory contains the components of the Solr4 system supporting
the CSpace "Portals"

There is one directory per UCB tenant, each directory contains the SQL and other
magic to refresh that tenant's Solr cores.

The instructions and code to install Solr and configure the cores is not here; look in the
`cspace-solr-ucb/utilities` directory for that. 

The crontab for the app_solr pseudo-user is now one line to run the Solr ETL piplines
at 03:01am nightly:

```bash
[app_solr@cspace-prod-01 ~]$ crontab -l
01 3 * * * /home/app_solr/one_job.sh >> /home/app_solr/refresh.log
```

This runs each museum refresh (which may have several cores) as a separate job ("oj.*.sh"), but
starts them at the same time (so the museums are refreshing in parallel).

The rationale for running all the solr refreshes (and some other processes) as a single script
is that it minimizes the total elapsed time and eliminates any chance of the jobs overlapping.

NB: as of November 2019, the 13 core refreshes take about 3 hours to run sequentially.

tS.py is a short script to test the (local) installation of the Python solr
client module and operation of the (local) solr server. To run:

```bash
$ python tS.py pahma-public
pahma-public, records found: 735314
```

(NB: solr must be running on localhost:8983 and have a core with the specified name)

Other contents of the app_solr working directory (which includes the content of this
GitHub directory):

checkstatus.sh - a script to display the contents of the UCB solr4 portals
                 and the status of the last refresh jobs.
one_job.sh - script to run all solr refresh and other extract processes.
optimize.log - output of optimize.sh (overwritten each time).
optimize.sh - runs the "optimize" process on each solr core. Not strictly
              necessary, but solr performs better.
solrdatasources - the ETL code (i.e. nightly scripts) to refresh the Portals.
cspace-solr-ucb - clone of the code repo. Needed for updates.
README.md - this file.
refresh.log - cumulative log of refreshes.


#### Initial Installation and Maintenance of ETL pipelines on RTL VMs (Ubuntu)

The following steps will setup the Solr ETL for UCB in ~app_solr.

NB:

* There is an optional step to change the settings to point to Dev or QA instead of Prod.
* This procedure _only_ deploys the ETL code on a managed server.
it presumes that you have already installed and started Solr, and have
configured the appropriate cores. (Installing Solr is an Ops task see the README.md in the `utilities` directory for
how to do that.)
* In general, development work on the Solr ETL is done on Dev and not one's local dev system: 
running the SQL would require tunneling, and be very, very slow. One _could_, though!

```bash
# ssh to a server
ssh cspace-dev.cspace.berkeley.edu
sudo su - app_solr
# assumes that Solr is up and running, see above
git clone https://github.com/cspace-deployment/cspace-solr-ucb
cspace-solr-ucb/utilities/redeploy-etl.sh
#
# To simply update the ETL code for a single tenant ON PROD, providing that the updated code is
# in GitHub already:
#
cd ~/cspace-solr-ucb
git pull -v
# checkout version A.B.C
git checkout A.B.C
cp -r datasources/pahma/* ~/solrdatasources/pahma
#
# OPTIONAL STEPS:
#
# To make the prod scripts into dev or qa scripts:
# ymmv! the following used to work (July 2019), but port number and hostnames are prone to change
cd ~
./switch2dev.sh
#or
./switch2qa.sh

# setup pgpass, if it is not already set up.
cat > .pgpass
vi .pgpass
chmod u+rw .pgpass
ls -ltr .pgpass
```

#### Testing the Solr ETL pipelines

To redeploy all pipeline code on any of the 3 RTL server (-dev, -qa, -prod):

```bash
ssh ... to the server
sudo su - app_solr
cspace-solr-ucb/utilities/redeploy-etl.sh 6.0.5-rc6
cspace-solr-ucb/utilities/switch2dev.sh
# to run all pipelines (a couple hours on dev)
nohup ./one_job.sh &
```
Tidy up after youself: the redeploy move the current deploy directory out of the
way and you may wish to get rid of the old versions from time to time, e.g.:
```bash
rm -rf solrdatasources.20200924
```
To run individual pipelines, invoke the appropriate `solrETL-*sh` script, e.g.:
```bash
# try reloading a couple of cores 'by hand'. the small ones: takes a few minutes for each
nohup /home/app_solr/solrdatasources/bampfa/solrETL-public.sh bampfa >> /home/app_solr/logs/bampfa.solr_extract_public.log 2>&1 &
nohup /home/app_solr/solrdatasources/botgarden/solrETL-public.sh botgarden >> /home/app_solr/logs/botgarden.solr_extract_public.log &
# did they work?
./checkstatus.sh -v

# now load the solr cores; couple ways to do this:
# Provided you have access to the Postgres server, you can run the refresh job (takes a few hours):
nohup one_job.sh >> /home/app_solr/refresh.log &
```

#### Finding stuff in your Solr cores"

Often it is useful to be able to check for stuff in one of the Solr cores.

Locally, the "Solr admin panel" is a great tool. If solr is running locally, it should be available at:

http://localhost:8983/solr/

You can tunnel to it elsewhere, e.g.:

ssh -L 10000:localhost:8983 me@blacklight-dev.ets.berkeley.edu

and you will be able to see it at:

http://localhost:10000/solr/

If you want to see if your Solr cores are available and you have the Python Solr module
properly installed, you can use `tS.py`. Try:

`
python tS.py
`

in this very directory and debug from there.

For example, if you would like to run check to see if a list of PAHMA museum numbers actually exist, you 
could make a file of the museum numbers, one per line, and try:

`
python tS.py pahma-public http://localhost:8983 'objmusno_s:"%s"' < /tmp/objmusno_s.txt > objmusno_s.txt 
`

Caveats:

* You should read and understand these scripts before using them!
* Mostly these expect the "standard" Ubuntu OS infrastructure at RTL
* But they will mostly run on your Mac or local VM, perhaps with some tweaking.

```
