#!/bin/bash
# ========================================================================
# Fedora System Tools - Auto Maintenance
# Copyright (C) 2026 William Hutton
# ========================================================================
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="/var/log/fedora-tools"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
MAIN_LOG="$LOG_DIR/auto-maintenance-$TIMESTAMP.log"

RUN_BACKUP=true
RUN_CLEANUP=true
RUN_UPDATE=true
RUN_RAM=true
DRY_RUN=false

TASKS_PASSED=0
TASKS_FAILED=0
FAILED_TASKS=()

log() { echo -e "$1" | tee -a "$MAIN_LOG"; }

print_status()  { log "${GREEN}[✓]${NC} $1"; }
print_warning() { log "${YELLOW}[!]${NC} $1"; }
print_error()   { log "${RED}[✗]${NC} $1"; }
print_info()    { log "${BLUE}[i]${NC} $1"; }

show_help() {
    cat << EOF

${CYAN}Fedora Auto Maintenance Script${NC}

Runs backup, cleanup, system update, and RAM management in sequence.

USAGE:
    ./auto-maintenance.sh [OPTIONS]

OPTIONS:
    (none)       Run all maintenance tasks
    --dry-run    Preview what would happen without making changes
    --backup     Run only the backup task
    --cleanup    Run only the disk cleanup task
    --update     Run only the system update task
    --ram        Run only the RAM management task
    --help       Show this help message

LOG FILES:
    Main log: $LOG_DIR/auto-maintenance-<timestamp>.log
    Per-task: $LOG_DIR/<task>.log

