#!/bin/bash

#
# Run traefik local 
#

APP_NAME="traefik-dev"
arg="$1"

build() {
  docker build -t "$APP_NAME" .
}

restart() {
  docker restart "$APP_NAME"
  docker logs -f "$APP_NAME"
}

run() {
  docker build -t "$APP_NAME" . &&
  docker run --rm --name "$APP_NAME" -p 80:80 -p 443:443 -p 8080:8080 -v /var/run/docker.sock:/var/run/docker.sock "$APP_NAME" &&
  docker logs -f "$APP_NAME" || echo "Stopping $APP_NAME.."

  exit 0
}

help() {
  echo
  echo " traefik.sh"
  echo " Heeey, o docker precisa estar em swarm mode. Pf, rode: docker swarm init"
  echo " Depois pra sair do swarm mode: docker swarm leave --force"
  echo
  echo " run - Run traefik container"
  echo " stop - Just stop container"
  echo " restart - Resssssstarttt container"
  echo
}

case "$arg" in
  "restart")
  restart
  ;;
  "run")
  run
  ;;
  "build")
  build
  ;;
  "stop")
  stop
  ;;
  *)
  help
  ;;
esac
