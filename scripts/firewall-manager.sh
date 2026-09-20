#!/usr/bin/env bash
# ========================================================================
# Fedora System Tools - Firewall Manager
# Copyright (C) 2026 William Hutton
# ========================================================================

set -u
set -o pipefail

SCRIPT_NAME="$(basename "$0")"
VERSION="1.0.0"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

print_status()  { printf '%b[✓]%b %s\n' "$GREEN" "$NC" "$1"; }
print_warning() { printf '%b[!]%b %s\n' "$YELLOW" "$NC" "$1"; }
print_error()   { printf '%b[✗]%b %s\n' "$RED" "$NC" "$1" >&2; }
print_info()    { printf '%b[i]%b %s\n' "$BLUE" "$NC" "$1"; }

usage() {
    cat <<EOF
${CYAN}Fedora Firewall Manager${NC}

Manage the system firewall using firewalld.

USAGE:
    $SCRIPT_NAME [COMMAND] [OPTIONS]

COMMANDS:
    status                 Show firewall state and active zones
    list                  List all active rules
    services              List allowed services
    ports                 List allowed ports
    allow SERVICE|PORT    Allow a service or port
    remove SERVICE|PORT   Remove a service or port
    reload                Reload firewalld rules
    enable                Enable firewalld
    disable               Disable firewalld
    help                  Show this help message

EXAMPLES:
    ./$SCRIPT_NAME status
    ./$SCRIPT_NAME list
    ./$SCRIPT_NAME allow ssh
    ./$SCRIPT_NAME allow 8080/tcp
    ./$SCRIPT_NAME remove 8080/tcp
    ./$SCRIPT_NAME enable
    ./$SCRIPT_NAME disable

NOTE:
    Some commands require sudo or root privileges.
EOF
}

require_firewalld() {
    if ! command -v firewall-cmd >/dev/null 2>&1; then
        print_error "firewalld is not installed or not available in PATH."
        exit 1
    fi
}

ensure_root() {
    if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
        print_warning "This command may require root privileges."
        print_info "Try: sudo $SCRIPT_NAME $*"
    fi
}

show_status() {
    require_firewalld
    echo
    echo "=== Firewall Status ==="
    firewall-cmd --state
    echo
    echo "=== Active zones ==="
    firewall-cmd --get-active-zones
    echo
    echo "=== Default zone ==="
    firewall-cmd --get-default-zone
}

show_list() {
    require_firewalld
    firewall-cmd --list-all
}

show_services() {
    require_firewalld
    firewall-cmd --list-services
}

show_ports() {
    require_firewalld
    firewall-cmd --list-ports
}

allow_rule() {
    local rule="$1"

    if [[ -z "$rule" ]]; then
        print_error "No service or port provided."
        usage
        exit 1
    fi

    require_firewalld
    ensure_root

    if [[ "$rule" =~ ^[0-9]+/(tcp|udp)$ ]]; then
        firewall-cmd --permanent --add-port="$rule"
        firewall-cmd --reload
        print_status "Port allowed: $rule"
    elif [[ "$rule" =~ ^[a-zA-Z0-9._:-]+$ ]]; then
        firewall-cmd --permanent --add-service="$rule"
        firewall-cmd --reload
        print_status "Service allowed: $rule"
    else
        print_error "Invalid rule: $rule"
        print_info "Use a service name like ssh or a port like 8080/tcp."
        exit 1
    fi
}

remove_rule() {
    local rule="$1"

    if [[ -z "$rule" ]]; then
        print_error "No service or port provided."
        usage
        exit 1
    fi

    require_firewalld
    ensure_root

    if [[ "$rule" =~ ^[0-9]+/(tcp|udp)$ ]]; then
        firewall-cmd --permanent --remove-port="$rule"
        firewall-cmd --reload
        print_status "Port removed: $rule"
    elif [[ "$rule" =~ ^[a-zA-Z0-9._:-]+$ ]]; then
        firewall-cmd --permanent --remove-service="$rule"
        firewall-cmd --reload
        print_status "Service removed: $rule"
    else
        print_error "Invalid rule: $rule"
        exit 1
    fi
}

reload_firewall() {
    require_firewalld
    firewall-cmd --reload
    print_status "Firewall reloaded."
}

enable_firewall() {
    require_firewalld
    firewall-cmd --set-default-zone=public 2>/dev/null || true
    systemctl enable firewalld
    systemctl start firewalld
    print_status "firewalld enabled."
}

disable_firewall() {
    require_firewalld
    systemctl stop firewalld
    systemctl disable firewalld
    print_warning "firewalld disabled."
}

main() {
    if [[ $# -eq 0 ]]; then
        usage
        exit 0
    fi

    local command="$1"
    shift

    case "$command" in
        status)
            show_status
            ;;
        list)
            show_list
            ;;
        services)
            show_services
            ;;
        ports)
            show_ports
            ;;
        allow)
            allow_rule "${1:-}"
            ;;
        remove)
            remove_rule "${1:-}"
            ;;
        reload)
            reload_firewall
            ;;
        enable)
            enable_firewall
            ;;
        disable)
            disable_firewall
            ;;
        help|-h|--help)
            usage
            ;;
        --version|-v)
            echo "$SCRIPT_NAME $VERSION"
            ;;
        *)
            print_error "Unknown command: $command"
            usage
            exit 1
            ;;
    esac
}

main "$@"
