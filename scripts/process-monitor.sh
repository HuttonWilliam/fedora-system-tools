#!/usr/bin/env bash
# ========================================================================
# Fedora System Tools - Process Monitor
# Copyright (C) 2026 William Hutton
# ========================================================================

set -uo pipefail

readonly SCRIPT_NAME="$(basename "$0")"
readonly VERSION="1.0.0"
readonly DEFAULT_COUNT=10
readonly DEFAULT_INTERVAL=2

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

print_status() {
    printf '%b[✓]%b %s\n' "$GREEN" "$NC" "$1"
}

print_warning() {
    printf '%b[!]%b %s\n' "$YELLOW" "$NC" "$1"
}

print_error() {
    printf '%b[✗]%b %s\n' "$RED" "$NC" "$1" >&2
}

print_info() {
    printf '%b[i]%b %s\n' "$BLUE" "$NC" "$1"
}

usage() {
    cat <<EOF
${CYAN}Fedora Process Monitor${NC}

Monitor running processes and identify programs using CPU or memory.

USAGE:
    $SCRIPT_NAME [OPTION]

OPTIONS:
    --cpu [N]          Show the top N processes by CPU usage
    --memory [N]       Show the top N processes by memory usage
    --watch [SECONDS]  Continuously monitor processes
                       Default interval: ${DEFAULT_INTERVAL} seconds
    --find NAME        Search for a process by name or command
    --kill PID         Ask for confirmation, then terminate a process
    --report FILE      Save a process report to FILE
    --help             Show this help message
    --version          Show version information

EXAMPLES:
    ./$SCRIPT_NAME
    ./$SCRIPT_NAME --cpu 15
    ./$SCRIPT_NAME --memory 10
    ./$SCRIPT_NAME --watch 3
    ./$SCRIPT_NAME --find firefox
    ./$SCRIPT_NAME --kill 1234
    ./$SCRIPT_NAME --report "\$HOME/process-report.txt"

The --kill option sends a normal TERM signal only after confirmation.
EOF
}

version() {
    printf '%s %s\n' "$SCRIPT_NAME" "$VERSION"
}

require_commands() {
    local command_name

    for command_name in ps awk grep head date mkdir dirname kill; do
        if ! command -v "$command_name" >/dev/null 2>&1; then
            print_error "Required command not found: $command_name"
            exit 1
        fi
    done
}

is_positive_integer() {
    [[ "$1" =~ ^[1-9][0-9]*$ ]]
}

process_table() {
    local sort_type="$1"
    local count="$2"

    if [[ "$sort_type" == "memory" ]]; then
        ps -eo pid,user,pcpu,pmem,etime,args --sort=-pmem \
            | head -n "$((count + 1))"
    else
        ps -eo pid,user,pcpu,pmem,etime,args --sort=-pcpu \
            | head -n "$((count + 1))"
    fi
}

show_cpu_processes() {
    local count="$1"

    printf '%bTop %s Processes by CPU Usage%b\n' "$CYAN" "$count" "$NC"
    process_table "cpu" "$count"
}

show_memory_processes() {
    local count="$1"

    printf '%bTop %s Processes by Memory Usage%b\n' "$CYAN" "$count" "$NC"
    process_table "memory" "$count"
}

watch_processes() {
    local interval="$1"
    local count="$2"

    while true; do
        if command -v clear >/dev/null 2>&1; then
            clear
        fi

        printf '%bFedora Process Monitor%b\n' "$CYAN" "$NC"
        printf 'Refreshing every %s second(s). Press Ctrl+C to exit.\n\n' "$interval"
        printf 'Last updated: %s\n\n' "$(date '+%Y-%m-%d %H:%M:%S')"

        show_cpu_processes "$count"

        sleep "$interval" || break
    done
}

find_process() {
    local search_term="$1"
    local current_pid="$$"

    printf '%bProcesses matching: %s%b\n' "$CYAN" "$search_term" "$NC"

    ps -eo pid,user,pcpu,pmem,etime,args --sort=-pcpu \
        | awk -v term="$search_term" -v self="$current_pid" '
            NR == 1 {
                print
                next
            }
            index(tolower($0), tolower(term)) &&
            $1 != self &&
            $1 != 1 {
                print
            }
        '
}

kill_process() {
    local pid="$1"
    local process_command
    local answer

    if ! is_positive_integer "$pid"; then
        print_error "PID must be a positive integer."
        return 1
    fi

    if [[ "$pid" == "1" ]]; then
        print_error "Refusing to terminate PID 1."
        return 1
    fi

    if [[ "$pid" == "$$" ]]; then
        print_error "Refusing to terminate this script."
        return 1
    fi

    if ! kill -0 "$pid" 2>/dev/null; then
        print_error "No accessible process found with PID $pid."
        return 1
    fi

    process_command="$(ps -p "$pid" -o pid=,user=,pcpu=,pmem=,etime=,args= 2>/dev/null)"

    if [[ -z "$process_command" ]]; then
        print_error "Unable to read process information for PID $pid."
        return 1
    fi

    printf '%bSelected process:%b\n%s\n\n' "$YELLOW" "$NC" "$process_command"
    print_warning "This will send SIGTERM to the process."

    read -r -p "Continue? Type 'yes' to terminate: " answer

    if [[ "$answer" != "yes" ]]; then
        print_info "Termination cancelled."
        return 0
    fi

    if kill -TERM "$pid" 2>/dev/null; then
        print_status "SIGTERM sent to PID $pid."
        print_info "The process may need time to exit cleanly."
    else
        print_error "Unable to terminate PID $pid. You may need permission."
        return 1
    fi
}

write_report() {
    local report_file="$1"
    local report_dir

    report_dir="$(dirname "$report_file")"

    if ! mkdir -p "$report_dir" 2>/dev/null; then
        print_error "Unable to create report directory: $report_dir"
        return 1
    fi

    {
        echo "Fedora Process Report"
        echo "Generated: $(date '+%Y-%m-%d %H:%M:%S %Z')"
        echo "Hostname:  $(hostname)"
        echo
        echo "Processes sorted by CPU usage:"
        process_table "cpu" 20
        echo
        echo "Processes sorted by memory usage:"
        process_table "memory" 20
    } > "$report_file"

    if [[ $? -eq 0 ]]; then
        print_status "Process report saved to: $report_file"
    else
        print_error "Unable to write report: $report_file"
        return 1
    fi
}

main() {
    local mode="cpu"
    local count="$DEFAULT_COUNT"
    local interval="$DEFAULT_INTERVAL"
    local search_term=""
    local report_file=""
    local kill_pid=""
    local argument
    local next_argument

    require_commands

    while [[ $# -gt 0 ]]; do
        argument="$1"

        case "$argument" in
            --cpu)
                mode="cpu"
                shift

                if [[ $# -gt 0 && "$1" != -* ]]; then
                    count="$1"
                    shift
                fi
                ;;

            --memory)
                mode="memory"
                shift

                if [[ $# -gt 0 && "$1" != -* ]]; then
                    count="$1"
                    shift
                fi
                ;;

            --watch)
                mode="watch"
                shift

                if [[ $# -gt 0 && "$1" != -* ]]; then
                    interval="$1"
                    shift
                fi
                ;;

            --find)
                if [[ $# -lt 2 ]]; then
                    print_error "--find requires a process name."
                    exit 1
                fi

                mode="find"
                search_term="$2"
                shift 2
                ;;

            --kill)
                if [[ $# -lt 2 ]]; then
                    print_error "--kill requires a PID."
                    exit 1
                fi

                mode="kill"
                kill_pid="$2"
                shift 2
                ;;

            --report)
                if [[ $# -lt 2 ]]; then
                    print_error "--report requires a file path."
                    exit 1
                fi

                report_file="$2"
                shift 2
                ;;

            --help|-h)
                usage
                exit 0
                ;;

            --version|-v)
                version
                exit 0
                ;;

            *)
                print_error "Unknown option: $argument"
                echo
                usage
                exit 1
                ;;
        esac
    done

    if [[ "$mode" == "cpu" || "$mode" == "memory" ]]; then
        if ! is_positive_integer "$count"; then
            print_error "Process count must be a positive integer."
            exit 1
        fi
    fi

    if [[ "$mode" == "watch" ]]; then
        if ! is_positive_integer "$interval"; then
            print_error "Watch interval must be a positive integer."
            exit 1
        fi
    fi

    if [[ -n "$report_file" ]]; then
        write_report "$report_file"
        return $?
    fi

    case "$mode" in
        cpu)
            show_cpu_processes "$count"
            ;;

        memory)
            show_memory_processes "$count"
            ;;

        watch)
            watch_processes "$interval" "$count"
            ;;

        find)
            if [[ -z "$search_term" ]]; then
                print_error "Search term cannot be empty."
                exit 1
            fi

            find_process "$search_term"
            ;;

        kill)
            kill_process "$kill_pid"
            ;;

        *)
            print_error "Invalid monitor mode."
            exit 1
            ;;
    esac
}

main "$@"
