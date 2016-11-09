#!/bin/bash

SERVICE=$1
shift

ESCUALO_HOST=$@

log() {
  echo "[Escualo::Travis::Setup]" $1
}

ensure_travis_installed() {
  type travis >/dev/null 2>&1 || { log "ERROR: This script needs Travis CLI to work, please install it first."; exit 1; }
}

source $(dirname $0)/version

ensure_travis_installed

if [ -e escualo_rsa.enc ]; then
  log "escualo_rsa.enc found, skipping encryption"
else
  log "Encrypting escualo_rsa ssh key"
  travis encrypt-file escualo_rsa --add
fi

log "Encrypting hosts and adding them to .travis.yml"
travis encrypt ESCUALO_HOSTS=\"$ESCUALO_HOST\" --add env.global

log "Almost there! Please add the following section to your .travis.yml:"
echo ""
echo "after_success:"
echo "- wget https://raw.githubusercontent.com/mumuki/mumuki-escualo-deploy/master/travis_deploy && chmod u+x travis_deploy"
echo "- ./travis_deploy $SERVICE"
