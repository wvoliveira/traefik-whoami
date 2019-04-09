#!/usr/bin/env bash
#
# Deploy
#

SERVICE_ENV="$1"
SERVICE_NAME="$2"
SERVICE_IMAGE="$3"
IMAGE_URL="${SERVICE_IMAGE}:v${BUILD_NUMBER}"

# override
SERVICE_NAME="${SERVICE_NAME}-${SERVICE_ENV}"

# Export DOCKER_HOSTS_DEPLOY
. ./jenkins/vars.sh "$SERVICE_ENV"


deploy_service() {

  for host in $(echo "$DOCKER_HOSTS_DEPLOY"); do
    export DOCKER_HOST="$host"

    echo
    echo "Environment: ${SERVICE_ENV}"
    echo "Docker host: ${DOCKER_HOST}"
    echo "Service name: ${SERVICE_NAME}"
    echo "Service image: ${IMAGE_URL}"
    echo "Build number: ${BUILD_NUMBER}"
    echo

    send_deploy_command

  done  
}

send_deploy_command() {

  code_service_exists=$(docker service inspect "$SERVICE_NAME" > /dev/null 2>&1; echo "$?")

  if [[ "$code_service_exists" == "1" ]]; then

    echo "Creating service ${SERVICE_NAME}.."
    docker service create --name "$SERVICE_NAME" \
    --network traefik \
    --mode global \
    --constraint 'node.role == manager' \
    --publish 80:80 \
    --publish 443:443 \
    --publish 8080:8080 \
    --mount type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock,ro \
    --mount type=bind,source=/etc/hostname,target=/etc/hostname,ro \
    --hostname "{{.Node.Hostname}}" \
    --restart-condition on-failure \
    --restart-max-attempts 3 \
    --restart-window 1m \
    --update-failure-action rollback \
    "$IMAGE_URL"

  elif [[ "$code_service_exists" == "0" ]]; then

    echo "Updating service ${SERVICE_NAME}.."
    docker service update \
    --publish-add 80:80 \
    --publish-add 443:443 \
    --publish-add 8080:8080 \
    --update-failure-action rollback \
    --update-parallelism "$UPDATE_PARALLELISM" \
    --update-delay "$UPDATE_DELAY" \
    --limit-memory "$LIMIT_MEMORY" \
    --image "$IMAGE_URL" \
    "$SERVICE_NAME"

  fi
}

main() {
  deploy_service
}

main
