#!/bin/bash
# ========================================================================
# Fedora System Tools - battery-monitor
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

BATTERY_PATH=""

show_help() {
    cat << EOF
Battery Health Monitor - Monitor battery health and power usage

USAGE:
    ./battery-monitor.sh [OPTIONS]

OPTIONS:
    --health          Show detailed battery health information
    --powersave on    Enable power-saving profile mode
    --powersave off   Disable power-saving mode (switches to balanced)
    --watch           Monitor battery in real-time (updates every 5 seconds)
    --help            Display this help message

EXAMPLES:
    ./battery-monitor.sh                 # Show current battery status
    ./battery-monitor.sh --health        # Show detailed health info
    ./battery-monitor.sh --powersave on  # Enable power-saving mode
    ./battery-monitor.sh --watch         # Monitor battery in real-time

