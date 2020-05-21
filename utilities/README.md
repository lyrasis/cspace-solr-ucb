## Solr8 helpers for UCB CSpace webapps

Tools (mainly shell scripts) to:

* deploy solr8 on Unix-like systems (Mac, Linux, perhaps even Unix).
* load the existing UCB solr datastores into the solr8 deployment.
* start and stop the solr service.
* run the Solr ETL pipelines (but the pipeline scripts themselves are not here: see museum repos)

Currently there are 7 tools, some mature, but mostly unripe, raw, and needy:

* scp4solr.sh -- attempts to scp (copy via ssh) the available nightly solr extracts
* curl4solr.sh --  attempts to cURL the available nightly solr public extracts from the Production server
* make_curls.sh -- script to extract the latest cURL commands to do the POSTing to Solr. creates allcurls.sh
* allcurls.sh -- (EXAMPLE ONLY!) clears out and refreshes all UCB solr cores (provide you have the input files!)
* checkstatus.sh -- *on UCB managed servers only* this script checks the ETL logs and counts records in all the solr cores
* countSolr8.sh -- if your Solr8 server is running, this script will count the records in the UCB cores
* tS.py -- a script to test your "solrpy" module and connectivity to Solr

#### Suggestions for "local installs" of Solr

e.g. on your Macbook or Ubuntu labtop, for development. Sorry, no help for Windows here!

(for installs on RTL servers, consult Ops.)

The essence:

* Install Solr8
* Start the Solr8 server
* Configure for UCB solr datastores using the scripts provided.
* Obtain the latest data extracts from UCB servers
* Unzip and load the extracts
* Verify Solr8 server works

NB: in general, you won't be running the Solr ETL pipelines locally, that's why we copy the
'extracts' that are published on webapps.cspace.berkeley.edu. Only the public extracts are available.
If you want to have the *-internal cores populated, you'll need to scp them from webapps.cspace.b.e or
otherwise arrange to obtain them. Inasmuch as there is sensitive info in those internal cores, caution
should be exercised in hosting them on your local system; in general it should not be necessary since
you can get access to them by tunneling to one of the RTL servers.

NB: if solr is *already* running, you'll need to
kill or stop it in order to start it again so it will see the new cores.
here's one way to do it:
```bash
ps aux | grep solr
kill <thatsolrprocess>
```
...But there are others. consult your friendly solr operator to find out how best to stop
and eventually get rid of an existing solr server.

It is possible that you'll need to co-exist with existing solr operations; such
co-existence is feasible, probably not even that hard, but is beyond the scope of
these instructions.

```bash
# 1. Obtain the code need (mainly bash scripts) from GitHub
#
# (you'll need to clone the repo with all the tools in it...)
#
# let's assume that for now you'll put the solr8 data in your home directory.
cd ~
git clone https://github.com/cspace-deployment/cspace-solr-ucb

# 2. Get solr8
wget ....
gunzip ...
mv solr8-.... solr8

# try it out
cd ~/solr8
bin/solr start

# 3. You should now be able to see the Solr8 admin console in your browser:
#
#    http://localhost:8983/solr/
#
# 4. update the cores and schema for ucb
#
# NB: clone the cspace-solr-ucb repo if you haven't already
#
cd ~
git clone https://github.com/cspace-deployment/cspace-solr-ucb
cd ~/cspace-solr-ucb/solr-cores
# you'll need to edit the SOLR_CMD in makesolrcores.sh to match where you put solr
./makesolrcores.sh ~/cspace-solr-ucb
#
#    http://localhost:8983/solr/
#
#    You should have a bunch of empty solr cores named things like "bampfa-public", "pahma-internal", etc.
#
#    You can also check the contents of the solr server using the countSolr8.sh script:
#
~/cspace-solr-ucb/utilities/countSolr8.sh
#
# 5. if you want to populate your cores using 'nightly exracts', then...
#
# first, make a directory to keep things neat and tidy:
cd ~
mkdir 4solr
cd 4solr
#
# then, there are several ways to get the files:
#
# to get a subset of the dumps (i.e. the public ones), you can download them via HTTP:
~/cspace-solr-ucb/utilities/curl4solr.sh
# or
~/cspace-solr-ucb/utilities/wget4solr.sh
# or, if you have ssh access to either Dev or Prod, you can scp them:
~/cspace-solr-ucb/utilities/scp4solr.sh mylogin@webapps.cspace.berkeley.edu
#
# NB: this script makes *a lot* of assumptions!
# * You must be able to connect to the CSpace production or development servers,
#   cspace-(prod,dev).cspace.berkeley.edu
#   via secure connection, i.e. ssh.
#   to check if you can get in, try "ssh mylogin@cspace-prod.cspace.berkeley.edu". if this does not
#   work, debug that issue first before proceeding.
# * If you're off-campus, you will probably need a VPN connection. The only evidence of this
#   might be that invoking the script does nothing -- just hangs.
#   You don't need to use the script. You can simply try the following:
#       scp <your-dev-login>@cspace-prod.cspace.berkeley.edu:/tmp/4solr*.gz .
# * You may not have credentials for Prod (only dev). In this case, try:
#       scp <your-dev-login>@cspace-dev.cspace.berkeley.edu:/tmp/4solr*.gz .
#   (this will get you whatever is on Dev, which may not be the latest versions)
# * In any case, if you have to do the scp by hand, you'll also need to uncompress the files by hand:
#       gunzip -f 4solr*.gz
# * Be patient: it may take a while -- 10-20 minutes -- to download all the files. They're a bit big.
#
# 6. execute the script to load all the .csv dump files (take 15 mins or so...some biggish datasources!)
#
#    this script cleans out each solr core and then loads the dump file.
#    all the work is done via HTTP
#
# IMPORTANT!! the specifics of the cURLs to refresh the solr cores change frequently
# make sure you get the right ones -- you may need to recreate the allcurls.sh
# script on Production using the make_curls.sh script...
#
nohup ~/cspace-solr-ucb/utilities/allcurls.sh
# (takes a while, well over an hour. ergo the nohup...)
#
#    as noted above, you can check the contents of your Solr cores in the admin console or via
#    a script, as described in 4. above.
#
# 7. Clean up, if you wish
#
rm -rf ~/4solr
#
# You should now have some "live data" in Solr8! Enjoy!
#
```

#### Differences between Dev and Prod deployments

There are only a few differences between the "pipeline code" as deployed on Dev and as deployed on Prod. (The
files committed on GitHub are set up for Production; they need some minor edits when deployed on Dev.)

* The Postgres servers of course are different (hostname and port numbers).
* Several of the scripts send email. On Dev, these emails addresses should be changed to something appropriate: no
need to bug everyone with Dev output!
* Usually I keep the Dev Solr cores updated with data from Production. This way, the Dev portals more
closely resemble their production counterparts. Therefore, in app_solr's home directory there is a subdirectory
`/4solr` that contains the refresh files from Prod, along with a script to fetch them from Prod (via wget) and to POST
them to Solr. However, when testing changes to the pipelines, one should run the pipeline on Dev and check results.
Later it may be prudent to put the production data back...
* There is no need (in general) to run the Solr refresh scripts nightly: nothing changes much on Dev! Therefore, the
cron job to run the refreshes (`one_job.sh`) is commented out in the `crontab`

Here are the diffs one can expect between the pipeline files as committed to GitHub and as deployed on Dev.

```
$ diff -r ~/cspace-solr-ucb solrdatasources | grep -v Only > diffs
$ cat diffs

diff -r /home/app_solr/cspace-solr-ucb/bampfa/bampfa_collectionitems_vw.sh solrdatasources/bampfa/bampfa_collectionitems_vw.sh
8c8
< SERVER="dba-postgres-prod-45.ist.berkeley.edu port=5313 sslmode=prefer"
---
> SERVER="dba-postgres-dev-45.ist.berkeley.edu port=5114 sslmode=prefer"
12c12
< CONTACT="osanchez@berkeley.edu"
---
> CONTACT="jblowe@berkeley.edu"
diff -r /home/app_solr/cspace-solr-ucb/bampfa/bampfa_website_extract.sh solrdatasources/bampfa/bampfa_website_extract.sh
8c8
< SERVER="dba-postgres-prod-45.ist.berkeley.edu port=5313 sslmode=prefer"
---
> SERVER="dba-postgres-dev-45.ist.berkeley.edu port=5114 sslmode=prefer"
12c12
< CONTACT="osanchez@berkeley.edu"
---
> CONTACT="jblowe@berkeley.edu"
diff -r /home/app_solr/cspace-solr-ucb/bampfa/solrETL-internal.sh solrdatasources/bampfa/solrETL-internal.sh
11c11
< SERVER="dba-postgres-prod-45.ist.berkeley.edu port=5313 sslmode=prefer"
---
> SERVER="dba-postgres-dev-45.ist.berkeley.edu port=5114 sslmode=prefer"
54c54
---
diff -r /home/app_solr/cspace-solr-ucb/bampfa/solrETL-public.sh solrdatasources/bampfa/solrETL-public.sh
21c21
< SERVER="dba-postgres-prod-45.ist.berkeley.edu port=5313 sslmode=prefer"
---
> SERVER="dba-postgres-dev-45.ist.berkeley.edu port=5114 sslmode=prefer"
66c66
---
diff -r /home/app_solr/cspace-solr-ucb/botgarden/solrETL-internal.sh solrdatasources/botgarden/solrETL-internal.sh
46c46
---
diff -r /home/app_solr/cspace-solr-ucb/botgarden/solrETL-propagations.sh solrdatasources/botgarden/solrETL-propagations.sh
20c20
< SERVER="dba-postgres-prod-45.ist.berkeley.edu port=5313 sslmode=prefer"
---
> SERVER="dba-postgres-dev-45.ist.berkeley.edu port=5114 sslmode=prefer"
58c58
---
70c70
---
diff -r /home/app_solr/cspace-solr-ucb/botgarden/solrETL-public.sh solrdatasources/botgarden/solrETL-public.sh
20c20
< SERVER="dba-postgres-prod-45.ist.berkeley.edu port=5313 sslmode=prefer"
---
> SERVER="dba-postgres-dev-45.ist.berkeley.edu port=5114 sslmode=prefer"
102c102
---
diff -r /home/app_solr/cspace-solr-ucb/cinefiles/scripts/cinefiles_denorm_nightly.sh solrdatasources/cinefiles/scripts/cinefiles_denorm_nightly.sh
20,21c20,21
< export PGHOST=dba-postgres-prod-45.ist.berkeley.edu
< export PGPORT=5313
---
> export PGHOST=dba-postgres-dev-45.ist.berkeley.edu
> export PGPORT=5114
diff -r /home/app_solr/cspace-solr-ucb/cinefiles/solrETL-public.sh solrdatasources/cinefiles/solrETL-public.sh
18c18
< SERVER="dba-postgres-prod-45.ist.berkeley.edu port=5313 sslmode=prefer"
---
> SERVER="dba-postgres-dev-45.ist.berkeley.edu port=5114 sslmode=prefer"
22c22
< CONTACT="cspace-support@lists.berkeley.edu"
---
> CONTACT="jblowe@berkeley.edu"
diff -r /home/app_solr/cspace-solr-ucb/pahma/solrETL-internal.sh solrdatasources/pahma/solrETL-internal.sh
46c46
---
diff -r /home/app_solr/cspace-solr-ucb/pahma/solrETL-locations.sh solrdatasources/pahma/solrETL-locations.sh
17c17
< HOSTNAME="dba-postgres-prod-45.ist.berkeley.edu port=5307 sslmode=prefer"
---
> HOSTNAME="dba-postgres-dev-45.ist.berkeley.edu port=5117 sslmode=prefer"
65c65
---
diff -r /home/app_solr/cspace-solr-ucb/pahma/solrETL-osteology.sh solrdatasources/pahma/solrETL-osteology.sh
16c16
< HOSTNAME="dba-postgres-prod-45.ist.berkeley.edu port=5307 sslmode=prefer"
---
> HOSTNAME="dba-postgres-dev-45.ist.berkeley.edu port=5117 sslmode=prefer"
55c55
---
diff -r /home/app_solr/cspace-solr-ucb/pahma/solrETL-public.sh solrdatasources/pahma/solrETL-public.sh
25c25
< SERVER="dba-postgres-prod-45.ist.berkeley.edu port=5307 sslmode=prefer"
---
> SERVER="dba-postgres-dev-45.ist.berkeley.edu port=5117 sslmode=prefer"
29c29
< CONTACT="mtblack@berkeley.edu"
---
> CONTACT="jblowe@berkeley.edu"
172c172
---
diff -r /home/app_solr/cspace-solr-ucb/ucjeps/solrETL-media.sh solrdatasources/ucjeps/solrETL-media.sh
11c11
< SERVER="dba-postgres-prod-45.ist.berkeley.edu port=5310 sslmode=prefer"
---
> SERVER="dba-postgres-dev-45.ist.berkeley.edu port=5119 sslmode=prefer"
34c34
---
diff -r /home/app_solr/cspace-solr-ucb/ucjeps/solrETL-public.sh solrdatasources/ucjeps/solrETL-public.sh
20c20
< SERVER="dba-postgres-prod-45.ist.berkeley.edu port=5310 sslmode=prefer"
---
> SERVER="dba-postgres-dev-45.ist.berkeley.edu port=5119 sslmode=prefer"
24c24
< CONTACT="ucjeps-it@berkeley.edu"
---
> CONTACT="jblowe@berkeley.edu"
88c88
---
```

#### Installing solr8 as a service on UCB VMs

Check with Ops

#### Additional first time installation considerations


- ucbg needs the gbif pickle file and 'requests'. get a copy from prod_
```
pip3 install requests
cd ~/solrdatasources/botgarden/gbif/
wget https://webapps.cspace.berkeley.edu/names.pickle

rm logs/*
nohup /home/app_solr/one_job.sh >> /home/app_solr/refresh.log &
```
- to refresh the dev cores from recent production extracts
```
cd ~/4solr/
./curl4solr.sh

curl -O https://webapps.cspace.berkeley.edu/allcurls.sh
chmod +x allcurls.sh
gunzip *.gz &
nohup time ./allcurls.sh
```
- perhaps the following, too?
```
less bin/solr.cmd
less bin/init.d/solr
ulimit -n
cat /etc/security/limits.d/solr.conf
apt install haveged
man haveged
sysctl kernel.random.entropy_avail
cat /etc/security/limits.d/solr.conf
```

####  Testing Solr queries

Certain search terms are supposed to handled specially. For example:

* singulars and plurals should produce the same search results.
* Same for terms that do (or do not) contain special characters, such as terms with diacritics.
* The English possesive 's should be handled correctly.

There's a script and a test file for that! Here's how it works:

```
$ python query-test-cases.py https://webapps-dev.cspace.berkeley.edu/solr/pahma-public query-test-cases.pahma.txt 
Métraux vs Metraux: 886 OK
Luiseño vs Luiseno: 377 OK
Diegueño vs Diegueno: 486 OK
Kantō vs Kanto: 255 OK
Kyūshū vs Kyushu: 78 OK
Kończyce vs Konczyce: 1 OK
Vértesszőlős vs Vertesszolos: 1 OK
Gårslev vs Garslev: 2 OK
Røros vs Roros: 1 OK
Appliqué vs Applique: 765 OK
Æ vs AE: 3570 OK
Basket vs Baskets: 14273 OK
Femur vs Femurs: 1365 OK
Filipino vs Filipinos: 2527 OK
Comb vs Combs: 601 OK
MacKinley vs McKinley: 0 does not equal 605
Eskimo vs Eskimaux: 6054 does not equal 0
Humerus vs Humeri: 1282 OK
```

