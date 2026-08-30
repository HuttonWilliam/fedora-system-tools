#!/bin/bash
# ========================================================================
# Fedora System Tools - backup-manager
# Copyright (C) 2026 William Hutton
# ========================================================================
set -e 

# Colors for clean terminal output
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║            Fedora Home Backup Manager                ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${NC}"

# Define variables
SOURCE_DIR="$HOME"
BACKUP_DIR="$HOME/Backups"

# Create the backup folder if it doesn't exist
mkdir -p "$BACKUP_DIR"

echo "-----------------------------------"
echo "🚀 Starting Full Home Backup..."
echo "Source: $SOURCE_DIR"
echo "Destination: $BACKUP_DIR"
echo "-----------------------------------"

# Run rsync smoothly
# -a: archive mode (keeps permissions and timestamps)
# -v: verbose (shows you what is happening)
# --delete: removes files from backup if you deleted them from Home
# --exclude: ignores the backup folder itself to avoid an infinite loop
rsync -av --delete --exclude='Backups/' --exclude='.cache/' "$SOURCE_DIR/" "$BACKUP_DIR/"

echo "-----------------------------------"
echo -e "${GREEN}✅ Success! Your $HOME folder is backed up.${NC}"
echo "Backup Size: $(du -sh "$BACKUP_DIR" | cut -f1)"
echo "-----------------------------------"
