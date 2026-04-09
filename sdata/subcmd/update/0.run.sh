#!/usr/bin/env bash
# This script is meant to be sourced by ./setup update

set -euo pipefail

prevent_sudo_or_root

REPO_ROOT="$(pwd)"
LOCK_FILE="${REPO_ROOT}/.update.lock"

log_header "Update repository from origin/main)"

# Lock to prevent concurrent runs
if [[ -f "$LOCK_FILE" ]]; then
  if kill -0 "$(cat "$LOCK_FILE" 2>/dev/null)" 2>/dev/null; then
    log_die "Another update is running (PID: $(cat "$LOCK_FILE"))"
  else
    log_warning "Stale lock found, removing..."
    rm -f "$LOCK_FILE"
  fi
fi

if [[ "$DRY_RUN" != true ]]; then
  echo $$ > "$LOCK_FILE"
fi

trap 'rm -f "$LOCK_FILE" 2>/dev/null' EXIT INT TERM

# Check git repo
if [[ ! -d .git ]]; then
  log_die "Not a git repository"
fi

current_branch=$(git branch --show-current 2>/dev/null || echo "")
if [[ "$current_branch" != "main" ]]; then
  log_warning "Not on main branch ('$current_branch'). Switching..."
  if [[ "$DRY_RUN" != true ]]; then
    git checkout main || log_die "Failed to checkout main"
  fi
  [[ "$VERBOSE" == true ]] && log_info "[DRY-RUN] Would checkout main"
fi

git_auto_unshallow

# Step 1: Fetch
if [[ "$VERBOSE" == true ]]; then log_info "Fetching from origin..."; fi
if [[ "$DRY_RUN" != true ]]; then
  if ! git fetch origin; then
    log_error "Fetch failed. Check network/remote."
    showhelp
    exit 1
  fi
else
  echo "[DRY-RUN] git fetch origin"
fi

# Step 2: Pull based on mode
if [[ "${MODE:-safe}" == "safe" ]]; then
    log_info "Safe pull..." ; fi
  if [[ "$DRY_RUN" != true ]]; then
    if ! git pull origin main; then
      log_error "Save pull failed (local changes/diverged?). Try -f."
      showhelp
      exit 1
    fi
    log_success "Save pull completed"
  else
    echo "[DRY-RUN] git pull origin main"
  fi
elif [[ "${MODE:-safe}" == "force" ]]; then
  log_warning "FORCE MODE: Will discard ALL local changes!"
  if [[ "$DRY_RUN" != true ]]; then
    git checkout main
    git reset --hard origin/main
    git clean -fd
    log_success "Forced sync completed (local changes discarded)"
  else
    echo "[DRY-RUN] git checkout main && git reset --hard origin/main && git clean -fd"
  fi
else
  log_error "Invalid mode: ${MODE}"
  showhelp
  exit 1
fi

# Step 3: Submodules
if git submodule status --recursive | grep -E '^[+-U]' >/dev/null; then
  if [[ "$VERBOSE" == true ]]; then log_info "Updating submodules..."; fi
  if [[ "$DRY_RUN" != true ]]; then
    git submodule update --init --recursive
  else
    echo "[DRY-RUN] git submodule update --init --recursive"
  fi
fi

log_success "Repository updated successfully from latest stable branch"
log_info "Tip: Use './setup update -f' only when necessary (discards changes)."
