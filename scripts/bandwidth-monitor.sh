#!/bin/bash
# ========================================================================
# Fedora System Tools - Bandwidth Monitor
# Copyright (C) 2026 William Hutton
# ========================================================================
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Configuration
LOG_DIR="/var/log/fedora-tools"
BANDWIDTH_LOG="$LOG_DIR/bandwidth-history-$(date +%Y%m%d).log"
REFRESH_INTERVAL=2

print_status()  { echo -e "${GREEN}[✓]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[!]${NC} $1"; }
print_error()   { echo -e "${RED}[✗]${NC} $1"; }
print_info()    { echo -e "${BLUE}[i]${NC} $1"; }

show_help() {
    cat << EOF

${CYAN}Fedora Bandwidth Monitor${NC}

Real-time network bandwidth monitoring and per-process analysis.

USAGE:
    ./bandwidth-monitor.sh [OPTIONS]

OPTIONS:
    (none)           Real-time bandwidth monitor (Ctrl+C to stop)
    --summary        Show network interface summary and exit
    --top-processes  Show top bandwidth-consuming processes
    --interface IF   Monitor specific interface (e.g., eth0, wlan0)
    --duration SECS  Monitor for N seconds then exit
    --log-only       Log current bandwidth and exit (no monitor)
    --history        Show bandwidth history from today
    --help           Show this help message

