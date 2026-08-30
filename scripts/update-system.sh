#!/bin/bash
# ========================================================================
# Fedora System Tools - update-system
# Copyright (C) 2026 William Hutton
# ========================================================================
set -e

# Title: Full Fedora Updater
echo "🔄 Checking and installing updates..."

# This refreshes your repositories and upgrades everything at once
sudo dnf upgrade --refresh -y

echo "🧹 Cleaning up old files..."
sudo dnf autoremove -y
sudo dnf clean all

echo "✅ System is up to date!"
