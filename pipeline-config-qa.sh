#!/bin/bash

# for qa and dev deployments, we send notification email to nobody

export BAMPFA_SERVER="dba-postgres-dev-45.ist.berkeley.edu port=5113"
export BAMPFA_CONTACT="nobody@nowhere.edu"

export BOTGARDEN_SERVER="dba-postgres-dev-45.ist.berkeley.edu port=5113"
export BOTGARDEN_CONTACT="nobody@nowhere.edu"

export CINEFILES_SERVER="dba-postgres-dev-45.ist.berkeley.edu port=5113"
export CINEFILES_CONTACT="nobody@nowhere.edu"

# for cinefiles denorm script
export CINEFILES_PGHOST="dba-postgres-dev-45.ist.berkeley.edu"
export CINEFILES_PGPORT=5113

export PAHMA_SERVER="dba-postgres-dev-45.ist.berkeley.edu port=5107"
export PAHMA_CONTACT="nobody@nowhere.edu"

export UCJEPS_SERVER="dba-postgres-dev-45.ist.berkeley.edu port=5110"
export UCJEPS_CONTACT="nobody@nowhere.edu"

export SUPPORT_CONTACT="nobody@nowhere.edu"

source ${HOME}/set_platform.sh
