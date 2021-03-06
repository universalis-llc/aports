#!/bin/sh
set -e

readlink_f () {
  cd "$(dirname "$1")" > /dev/null
  filename="$(basename "$1")"
  if [ -h "$filename" ]; then
    readlink_f "$(readlink "$filename")"
  else
    echo "$(pwd -P)/$filename"
  fi
}

SELF=$(readlink_f "$0")
SCRIPT_PATH=$(dirname "$SELF")
exec "$SCRIPT_PATH"/elixir -e "Mix.start(); Mix.CLI.main()" -- "$@"
