#!/bin/bash
# ========================================================================
# Fedora System Tools - Network Health Diagnostics
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

# Configuration
PING_TIMEOUT=5
PING_COUNT=10
DNS_SERVERS=("8.8.8.8" "1.1.1.1" "208.67.222.222")
TEST_HOSTS=("google.com" "cloudflare.com" "github.com")
LOG_DIR="$HOME/logs/fedora-tools"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/network-health-$(date +%Y%m%d-%H%M%S).log"

print_status()  { echo -e "${GREEN}[✓]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[!]${NC} $1"; }
print_error()   { echo -e "${RED}[✗]${NC} $1"; }
print_info()    { echo -e "${BLUE}[i]${NC} $1"; }
log_output() { echo -e "$1" | tee -a "$LOG_FILE"; }

show_help() {
    cat << EOF

${CYAN}Fedora Network Health Diagnostic Tool${NC}

Comprehensive network diagnostics including latency, DNS, speed tests, and stability.

USAGE:
    ./network-health.sh [OPTIONS]

OPTIONS:
    (none)           Run all diagnostics
    --quick          Quick connectivity check only
    --latency        Test latency to multiple hosts
    --dns            Test DNS resolver functionality
    --speed          Perform speed test (requires speedtest-cli)
    --stability      Run 5-minute stability test
    --routes         Display routing table
    --interface      Show detailed network interface info
    --help           Show this help message

LOG FILES:
    Results saved to: $LOG_DIR/network-health-<timestamp>.log

DEPENDENCIES:
    - ping, curl (standard)
    - bind-utils, bc (required, checked automatically)
    - speedtest-cli (optional for speed tests)
EOF
}
# Parse arguments
case "${1:-}" in
    --help) show_help; exit 0 ;;
esac

# Dependency check
check_dependencies() {
    local missing=()
    command -v ping &>/dev/null || missing+=("iputils")
    command -v dig &>/dev/null || missing+=("bind-utils")
    command -v bc &>/dev/null || missing+=("bc")
    command -v curl &>/dev/null || missing+=("curl")

    if [ ${#missing[@]} -gt 0 ]; then
        print_error "Missing dependencies: ${missing[*]}"
        echo "Install with: sudo dnf install ${missing[*]}"
        exit 1
    fi
    print_status "All dependencies found"
}

# Run diagnostics
run_all() {
    log_output "Network Health Check - $(date)"
    check_dependencies
    # ... your ping, DNS, latency tests here ...
}

run_all
