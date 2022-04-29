
# for qa and dev deployments, we send notification email to nobody

export BAMPFA_SERVER="dba-postgres-dev-45.ist.berkeley.edu port=5114"
export BAMPFA_CONTACT="nobody@berkeley.edu"

export BOTGARDEN_SERVER="dba-postgres-dev-45.ist.berkeley.edu port=5114"
export BOTGARDEN_CONTACT="nobody@berkeley.edu"

export CINEFILES_SERVER="dba-postgres-dev-45.ist.berkeley.edu port=5114"
export CINEFILES_CONTACT="nobody@berkeley.edu"

export PAHMA_SERVER="dba-postgres-dev-45.ist.berkeley.edu port=5117"
export PAHMA_CONTACT="nobody@berkeley.edu"

export UCJEPS_SERVER="dba-postgres-dev-45.ist.berkeley.edu port=5119"
export UCJEPS_CONTACT="nobody@berkeley.edu"

export SUPPORT_CONTACT="nobody@berkeley.edu"

source ${HOME}/set_platform.sh