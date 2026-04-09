#!/usr/bin/env bash
# Handle args for subcmd: update
# shellcheck shell=bash

showhelp(){
echo -e "Syntax: $0 update [OPTIONS]...

Update repository from remote main branch.

Options:
  -h, --help                     Show this help message
  -n, --safe                     Update safe (default)
  -f, --force                    Forced update (reset --hard origin/main + clean, discards local changes!)
  -v, --verbose                  Verbose output 
  -d, --dry-run                  Dry-run mode (show commands only)

Examples:
  ./setup update                    # Update safe
  ./setup update -f                 # Update forced
  ./setup update -v -d              # --verbose --dry-run
"
}

para=$(getopt \
  -o hfnvd \
  -l help,safe,force,verbose,dry-run \
  -n "$0" -- "$@")
[ $? != 0 ] && echo "$0: Error when getopt, please recheck parameters." && exit 1

MODE="safe"
VERBOSE=false
DRY_RUN=false

eval set -- "$para"
while true ; do
  case "$1" in
    -h|--help) showhelp; exit 0 ;;
    --) break ;;
    *) shift ;;
  esac
done

eval set -- "$para"
while true ; do
  case "$1" in
    -n|--safe) MODE="safe"; shift ;;
    -f|--force) MODE="force"; shift ;;
    -v|--verbose) VERBOSE=true; shift ;;
    -d|--dry-run) DRY_RUN=true; shift;
      log_info "Dry-run mode enabled - no changes will be made" ;;
    --) break ;;
    *) echo -e "$0: Wrong parameters."; exit 1 ;;
  esac
done

[[ "$MODE" == "safe" ]] || log_info "Mode: $MODE"

