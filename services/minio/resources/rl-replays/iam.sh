#!/bin/sh
set -eu
mc alias set local http://minio.minio.svc:9000 "$MINIO_ROOT_USER" "$MINIO_ROOT_PASSWORD" >/dev/null

attach() {
  case "$(mc admin user info local "$2" --json)" in
    *"\"$1\""* | *"\"$1,"* | *",$1\""* | *",$1,"*) echo "$1 already attached to $2" ;;
    *) mc admin policy attach local "$1" --user "$2" ;;
  esac
}

mc mb --ignore-existing local/rl-replays
mc admin policy create local rl-replays-rw /policies/rl-replays-rw.json
mc admin policy create local rl-replays-read /policies/rl-replays-read.json
mc admin user add local "$WRITER_ACCESS_KEY" "$WRITER_SECRET_KEY"
mc admin user add local "$READER_ACCESS_KEY" "$READER_SECRET_KEY"
attach rl-replays-rw "$WRITER_ACCESS_KEY"
attach rl-replays-read "$READER_ACCESS_KEY"
mc admin user info local "$WRITER_ACCESS_KEY"
mc admin user info local "$READER_ACCESS_KEY"
