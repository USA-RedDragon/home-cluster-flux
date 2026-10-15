#!/bin/sh
set -eu
mc alias set local http://minio.minio.svc:9000 "$MINIO_ROOT_USER" "$MINIO_ROOT_PASSWORD" >/dev/null

attach() {
  case "$(mc admin user info local "$2" --json)" in
    *"\"$1\""* | *"\"$1,"* | *",$1\""* | *",$1,"*) echo "$1 already attached to $2" ;;
    *) mc admin policy attach local "$1" --user "$2" ;;
  esac
}

mc mb --ignore-existing local/sky-survey
mc admin policy create local sky-survey-rw /policies/sky-survey-rw.json
mc admin policy create local sky-survey-read /policies/sky-survey-read.json
mc admin policy create local sky-survey-tns-rw /policies/sky-survey-tns-rw.json
mc admin user add local "$WRITER_ACCESS_KEY" "$WRITER_SECRET_KEY"
attach sky-survey-rw "$WRITER_ACCESS_KEY"
attach sky-survey-read astro-stacker
attach sky-survey-tns-rw astro-stacker
mc admin user info local "$WRITER_ACCESS_KEY"
mc admin user info local astro-stacker
