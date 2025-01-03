#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

help="App symlinks fixer

Usage: ${0##*/} [-h | --help] [-n | --dry-run] [-v | --verbose]

Options:
  -h, --help                  show this help
  -n, --dry-run               perform a trial run with no changes made
  -v, --verbose               increase verbosity"

DRYRUN=0
VERBOSE=0

# options
while [[ "$#" -gt 0 && "$1" =~ ^- && ! "$1" == "--" ]]; do case "$1" in
  -h | --help )
    echo -e "${help}"
    exit
    ;;
  -n | --dry-run )
    DRYRUN=1
    ;;
  -v | --verbose )
    VERBOSE=1
    ;;
esac; shift; done
if [[ "$#" -gt 0 && "$1" == '--' ]]; then shift; fi

pushd "${0%/*}/../Gruvbox-Plus-Dark/apps/scalable" 1>/dev/null
# LibreOffice symlinks
libreoffice_args=$(awk -F= '$1=="Icon" && /[0-9]/ {print $2}' /usr/share/applications/libreoffice-*.desktop | awk -F- '{ print "libreoffice-" $2 ".svg " $0 ".svg" }')

if [[ "${DRYRUN}" -eq 1 || "${VERBOSE}" -eq 1 ]]; then
  echo "${libreoffice_args}" | awk '{ print $2 " → " $1}'
fi

if [[ "${DRYRUN}" -eq 0 ]]; then
  echo "${libreoffice_args}" | xargs -n2 ln -sfn
  if [[ "${VERBOSE}" -eq 1 ]]; then
    echo "Done."
  fi
else
  echo "Nothing done."
fi

popd 1>/dev/null
