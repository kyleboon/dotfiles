#!/usr/bin/env bash

set -euo pipefail

command -v navi >/dev/null 2>&1 || {
  cat >&2 << EOF
missing navi command line application, install with:
    brew install navi
You probably also want to add something like this to your .zshrc:
    if command -v navi >/dev/null 2>&1; then
      source <(navi widget zsh)
    fi
That will give you the ability to hit ctrl-G to bring navi up automatically
EOF
}

# resolve symlinks to get the real basedir of this script
BASE_DIR=$(dirname "$0")

INSTALL_DIR="$HOME/Library/Application Support/navi/cheats/kyleboon/"
mkdir -p "$INSTALL_DIR"

cd $BASE_DIR

for CHEAT in *.cheat; do
  cheat_path=$(realpath $CHEAT)
  echo "linking $cheat_path"
  ln -s "$cheat_path" "$INSTALL_DIR"
done
