#!/bin/sh
set -eu
mc alias set local http://minio.minio.svc:9000 "$MINIO_ROOT_USER" "$MINIO_ROOT_PASSWORD" >/dev/null

attach() {
  case "$(mc admin user info local "$2" --json)" in
    *"\"$1\""* | *"\"$1,"* | *",$1\""* | *",$1,"*) echo "$1 already attached to $2" ;;
    *) mc admin policy attach local "$1" --user "$2" ;;
  esac
}

mc mb --ignore-existing local/models
mc admin policy create local models-read /policies/models-read.json
attach models-read astro-stacker
mc admin user info local astro-stacker
