#!/bin/bash
# ========================================================================
# Fedora System Tools - sys-info
# Copyright (C) 2026 William Hutton
# ========================================================================
set -e

echo "--- 🖥️ FEDORA SYSTEM DASHBOARD ---"
if [ -f /etc/fedora-release ]; then
    echo "OS Release: $(cat /etc/fedora-release)"
fi
echo "Kernel:     $(uname -r)"

echo ""
echo "--- 💿 DISK & STORAGE TOPOLOGY ---"
lsblk -p -o NAME,SIZE,TYPE,MOUNTPOINT

echo ""
echo "--- 📊 MEMORY USAGE ---"
free -h

echo ""
echo "--- 📅 UPTIME ---"
uptime -p
