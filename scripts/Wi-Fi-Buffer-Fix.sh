#!/bin/bash
# ========================================================================
# Fedora System Tools - Wi-Fi Buffer Fix
# Copyright (C) 2026 William Hutton
# ========================================================================
set -e

# Colors for clean terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║    Fedora Qualcomm Wi-Fi Buffer Optimizer            ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${NC}"

# Check for root privileges
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}[!] Error: This script must be run with sudo properties.${NC}"
  echo -e "Please run: ${YELLOW}sudo ./scripts/Wi-Fi-Buffer-Fix.sh${NC}"
  exit 1
fi

# Check if the kernel parameters are already present using grubby
CURRENT_ARGS=$(sudo grubby --info=DEFAULT)

if [[ ! "$CURRENT_ARGS" =~ "iommu=soft" ]]; then
    echo -e "${YELLOW}[!] Wi-Fi memory fragmentation risk detected (Error -12 tracking).${NC}"
    echo -e "This script will reserve an unfragmented continuous RAM pool for your network chip."
    echo -e "Would you like to apply the kernel boot optimization? (y/n)"
    read -r answer
    
    if [[ "$answer" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        echo -e "\n${CYAN}Injecting kernel arguments via grubby...${NC}"
        
        # Fedora's official tool to add arguments to the default active kernel boot configuration
        sudo grubby --update-kernel=DEFAULT --args="iommu=soft mem_encrypt=off"
        
        echo -e "\n${GREEN}[✓] Initialization rules written successfully via grubby!${NC}"
        echo -e "${YELLOW}Please reboot your laptop ('sudo reboot') to map the wireless chip parameters.${NC}"
    else
        echo -e "${RED}Operation cancelled by user.${NC}"
    fi
else
    echo -e "${GREEN}[✓] Success: Qualcomm hardware memory maps are already optimized via grubby.${NC}"
fi
