Copyright © 2026 William Hutton
Licensed under the GNU General Public License v3.0 (GPLv3).
# Fedora System Tools 🛠️

This repository contains custom Bash scripts designed to optimize, monitor, and maintain Fedora workstations—tailored specifically for maximum performance, lower resource usage, and faster boot times.

## 📂 Project Structure

* **`scripts/`**: Core performance, maintenance, diagnostics, and optimization utilities.
* **`setup/`**: Automation installers for scheduling tasks.
* **Root**: Documentation (`README.md`, `AUTOMATION_GUIDE.md`) and project licensing.

---

## 📜 Available Scripts

### ⚙️ Boot & Kernel Optimizers

#### 🚀 System Boot Optimizer
* **Location**: `scripts/optimize-boot.sh`
* **Description**: Disables heavy graphical boot splash screens (`plymouth`) to stream raw text logs, and slashes the artificial GRUB countdown timer down to a hidden 1-second safety window.
* **How to use**: 
    ```bash
    sudo ./scripts/optimize-boot.sh
    ```

#### 📶 Wi-Fi Buffer Fix
* **Location**: `scripts/Wi-Fi-Buffer-Fix.sh`
* **Description**: Tweaks network buffer sizes and wireless power management states to eliminate latency spikes and drop-outs.
* **How to use**:
    ```bash
    sudo ./scripts/Wi-Fi-Buffer-Fix.sh
    ```

#### 🧠 RAM Manager
* **Location**: `scripts/ram-manager.sh`
* **Description**: Audits memory hogs, flushes inactive page caches safely, and optimizes memory allocation policies for low-RAM hardware.
* **How to use**:
    ```bash
    ./scripts/ram-manager.sh
    ```

---

### 🧹 Maintenance & Backups

#### 🧹 Disk Cleanup Utility
* **Location**: `scripts/disk-cleanup.sh`
* **Features**: Cleans `/tmp`, purges DNF/package manager caches, deletes logs older than 30 days, and empties trash. Includes a safe `--dry-run` preview mode.
* **How to use**:
    ```bash
    sudo ./scripts/disk-cleanup.sh
    sudo ./scripts/disk-cleanup.sh --dry-run
    ```

#### 💾 Backup Manager
* **Location**: `scripts/backup-manager.sh`
* **Features**: Automated, timestamped configurations/documents backups, restoration pipelines, and auto-purging of archives older than 30 days.
* **How to use**:
    ```bash
    ./scripts/backup-manager.sh create --name "before-update"
    ./scripts/backup-manager.sh restore --backup-id YYYYMMDD-HHMMSS
    ```

#### 🔄 System Update Streamliner
* **Location**: `scripts/update-system.sh`
* **Description**: One-touch script to handle DNF repository updates, package upgrades, and residual package removals.
* **How to use**:
    ```bash
    sudo ./scripts/update-system.sh
    ```

---

### 📊 Performance, Diagnostics & Logging

#### ⚡ System Performance Optimizer
* **Location**: `scripts/performance-tuner.sh`
* **Features**: Adjusts CPU governors (schedutil/ondemand), manages system swappiness settings, scales I/O schedulers, and generates performance diagnostic logs.
* **How to use**:
    ```bash
    ./scripts/performance-tuner.sh --optimize
    ./scripts/performance-tuner.sh --swap 10
    ```

#### 🔋 Battery Health Monitor
* **Location**: `scripts/battery-monitor.sh`
* **Features**: Analyzes power consumption, hardware degradation metrics, charge cycles, and scales battery-saving profiles.
* **How to use**:
    ```bash
    ./scripts/battery-monitor.sh --health
    ./scripts/battery-monitor.sh --watch
    ```

#### 📈 Disk Usage Analyzer
* **Location**: `scripts/disk-usage.sh`
* **Description**: Scans file systems to display overview metrics, flags the top 10 largest directories, and filters items by specified file sizes.
* **How to use**:
    ```bash
    ./scripts/disk-usage.sh --size 1G
    ```

#### 🛠️ Service Manager
* **Location**: `scripts/service-manager.sh`
* **Description**: Audits active `systemd` items and allows toggling of boot services to save background memory.
* **How to use**:
    ```bash
    ./scripts/service-manager.sh list
    sudo ./scripts/service-manager.sh disable cups
    ```

#### 🕵️ System Access Logger
* **Location**: `scripts/logger.sh`
* **Description**: Silently generates execution timestamps, user contexts, and system uptimes into a structured tracking file.
* **How to use**:
    ```bash
    ./scripts/logger.sh
    cat ~/Documents/access_report.txt
    ```

---

## 🤖 Automation Setup

You can schedule automated execution of these maintenance routines via interactive scripts included in the `setup/` directory.

### Option 1: Modern Systemd Timers (Recommended)
```bash
sudo ./setup/install-systemd-timers.sh
sudo ./setup/install-systemd-timers.sh --status
