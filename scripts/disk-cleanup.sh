#!/bin/bash
# ========================================================================
# Fedora System Tools - disk-cleanup
# Copyright (C) 2026 William Hutton
# ========================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Variables
DRY_RUN=false
TOTAL_FREED=0

show_help() {
    cat << EOF
Disk Cleanup Utility - Remove temporary files and reclaim disk space

USAGE:
    ./disk-cleanup.sh [OPTIONS]

OPTIONS:
    --dry-run    Show what would be deleted without actually deleting
    --help       Display this help message

EXAMPLES:
    ./disk-cleanup.sh              # Run cleanup
    ./disk-cleanup.sh --dry-run    # Preview changes first

CLEANUP TARGETS:
    - Temporary files (/tmp, /var/tmp)
    - Package manager cache (dnf, flatpak)
    - Old log files (>30 days)
    - Thumbnail cache
    - Trash bin

