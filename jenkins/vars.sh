#!/usr/bin/env bash
#
# Export VARS
#

SERVICE_ENV="$1"

# Docker inside docker in Jenkins
DOCKER_HOST_BUILD="<build host>:<port>"

# To deploy
if [[ -n "$SERVICE_ENV" ]]; then
  case "$SERVICE_ENV" in
    "testing") export \
      DOCKER_HOSTS_DEPLOY="<swarm-test-host>" ;;
    "staging") export \
      DOCKER_HOSTS_DEPLOY="<swarm-stag-host>" ;;
    "production") export \
      DOCKER_HOSTS_DEPLOY="<swarm-prod-dc01 swarm-prod-dc02>" ;;
  esac
fi

# Docker create and update policies
RESTART_MAX_ATTEMPTS="5"
RESTART_WINDOW="1m"
RESTART_CONDITION="any"
UPDATE_PARALLELISM="1"
UPDATE_DELAY="1s"
LIMIT_MEMORY="100M"
