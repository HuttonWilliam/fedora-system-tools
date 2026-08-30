## ⚙️ Technical Notes

### 🛠️ Design Philosophy
* **Resource Efficiency:** Tuned for efficient performance and optimized system management.
* **Fail-Fast Logic:** Every script begins with `set -e`. This ensures that if a command fails (e.g., lost internet during an update), the script stops immediately to prevent system corruption.
* **Differential Data Handling:** The backup system utilizes `rsync` rather than `cp`. This minimizes Disk I/O by only transferring files that have changed, which is critical for extending the life of older storage devices.

### 📦 Dependencies
The suite relies on standard Linux binaries usually pre-installed on Fedora:
* `rsync`: For intelligent file mirroring.
* `util-linux`: Provides `lsblk` for the disk topology dashboard.
* `dnf`: For core package management.

### 🐧 Compatibility
* **Primary OS:** Fedora Linux.
* **Hardware:** Tested and built for standard Fedora workstation hardware.
