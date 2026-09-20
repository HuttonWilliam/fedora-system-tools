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

#### 📶 Wi‑Fi Buffer Fix
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

#### 🧰 Auto Maintenance
* **Location**: `scripts/auto-maintenance.sh`
* **Description**: Runs a predefined maintenance sequence for backup, cleanup, updates, and memory optimization in a single workflow.
* **How to use**:
    ```bash
    ./scripts/auto-maintenance.sh
    ./scripts/auto-maintenance.sh --dry-run
    ```

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
* **Features**: Automated, timestamped configuration and documents backups, restoration pipelines, and auto-purging of archives older than 30 days.
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

#### 🌐 Bandwidth Monitor
* **Location**: `scripts/bandwidth-monitor.sh`
* **Description**: Real-time network bandwidth monitoring and per-process analysis.
* **How to use**:
    ```bash
    ./scripts/bandwidth-monitor.sh --summary
    ./scripts/bandwidth-monitor.sh --top-processes
    ./scripts/bandwidth-monitor.sh --history
    ```

#### 🧵 Process Monitor
* **Location**: `scripts/process-monitor.sh`
* **Description**: Displays the most resource-heavy processes, supports live monitoring, searches for a process by name, and can generate a report file.
* **How to use**:
    ```bash
    ./scripts/process-monitor.sh
    ./scripts/process-monitor.sh --cpu 15
    ./scripts/process-monitor.sh --memory 10
    ./scripts/process-monitor.sh --watch 3
    ./scripts/process-monitor.sh --find firefox
    ./scripts/process-monitor.sh --report "$HOME/process-report.txt"
    ```

#### 🔥 Firewall Manager
* **Location**: `scripts/firewall-manager.sh`
* **Description**: Manages the Fedora `firewalld` service, lists active rules, allows ports/services, and toggles firewall state.
* **How to use**:
    ```bash
    ./scripts/firewall-manager.sh status
    ./scripts/firewall-manager.sh list
    ./scripts/firewall-manager.sh allow ssh
    ./scripts/firewall-manager.sh allow 8080/tcp
    ./scripts/firewall-manager.sh remove 8080/tcp
    sudo ./scripts/firewall-manager.sh enable
    sudo ./scripts/firewall-manager.sh disable
    ```

#### 🔎 Network Health Check
* **Location**: `scripts/network-health.sh`
* **Description**: Performs connectivity and DNS health checks, verifies interfaces, and helps identify common networking issues.
* **How to use**:
    ```bash
    ./scripts/network-health.sh
    ```

#### 🕵️ System Access Logger
* **Location**: `scripts/logger.sh`
* **Description**: Silently generates execution timestamps, user contexts, and system uptimes into a structured tracking file.
* **How to use**:
    ```bash
    ./scripts/logger.sh
    cat ~/Documents/access_report.txt
    ```

#### 🛡️ Security Audit
* **Location**: `scripts/security-audit.sh`
* **Description**: Performs a broad system security audit covering package state, firewall health, users, permissions, and system hardening basics.
* **How to use**:
    ```bash
    ./scripts/security-audit.sh
    ```

#### 🖥️ System Information
* **Location**: `scripts/sys-info.sh`
* **Description**: Displays host, kernel, memory, disk, and system summary information.
* **How to use**:
    ```bash
    ./scripts/sys-info.sh
    ```

---

## 🤖 Automation Setup

You can schedule automated execution of these maintenance routines via interactive scripts included in the `setup/` directory.

### Option 1: Modern Systemd Timers (Recommended)
```bash
sudo ./setup/install-systemd-timers.sh
sudo ./setup/install-systemd-timers.sh --status
