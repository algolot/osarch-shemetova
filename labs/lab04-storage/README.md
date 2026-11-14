# Lab 4 —  Partition, mirror, fail, recoveк
shemetova
Machine: Windows 11 Pro (AMD Ryzen 7 7435HS, 24 GB RAM, 512 GB SSD), guests Ubuntu Server 26.04.1 LTS + Windows 11 Enterprise eval
Date: 14.11.2026

## What I did

### 1. Windows Guest Partitioning
* Attached an additional 2 GB virtual disk (`lab02-windows_1.vdi`) to the `lab02-windows` VM in VirtualBox.
* Initialized the new disk in **Disk Management** using the **GPT** (GUID Partition Table) partition style, matching the UEFI boot configuration of the primary OS disk and supporting modern volume management.
* Created a new simple volume spanning the entire disk, formatted it with **NTFS**, labeled it `LAB04`, and assigned it the drive letter **`E:`**.

### 2. Linux Guest RAID 1 Setup & Testing
* Attached three additional 2 GB virtual disks (`/dev/sdb`, `/dev/sdc`, and `/dev/sdd`) to `lab01-ubuntu` in VirtualBox while keeping the 25 GB system disk (`/dev/sda`) untouched.
* Recorded the initial disk layout using `lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS`.
* Created GPT partition tables and primary partitions with the `raid` flag enabled on `/dev/sdb` and `/dev/sdc` via `parted`.
* Installed `mdadm` and assembled a RAID 1 mirror across the two partitions by running `sudo mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1`.
* Formatted `/dev/md0` with `ext4`, mounted it at `/mnt/raid1`, and verified the healthy state (`[2/2] [UU]`, `State : clean`) via `cat /proc/mdstat` and `sudo mdadm --detail /dev/md0`.
* Created `/mnt/raid1/test.txt` containing `Lab 4 RAID 1 test - My data must survive disk failure` and recorded its initial SHA-256 checksum using `sha256sum /mnt/raid1/test.txt`.

### 3. Failure Simulation & Recovery
* Simulated a hardware failure by marking `/dev/sdc1` as faulty with `sudo mdadm /dev/md0 --fail /dev/sdc1`, confirming the degraded state (`[2/1] [U_]`).
* Read `/mnt/raid1/test.txt` and recalculated its SHA-256 checksum; the hash matched the original value (`bb2768263f1b94e287439d0116f928479a749e44bae1970d8a0dafa879d7e7d6`), proving data survival.
* Removed the failed partition using `sudo mdadm /dev/md0 --remove /dev/sdc1`, partitioned `/dev/sdd` with a GPT RAID partition (`/dev/sdd1`), and added it to the array via `sudo mdadm /dev/md0 --add /dev/sdd1`.
* Monitored the resync process until completion, confirming the array returned to a clean `[2/2] [UU]` state with `/dev/sdb1` and `/dev/sdd1` active.

---

## Disk Layout

| Stage | Target / RAID Members | State | Available Data / Details |
| :--- | :--- | :--- | :--- |
| **Windows Disk** | Disk 1 (`lab02-windows_1.vdi`) | Online / Healthy | GPT, NTFS, Drive `E:` (`LAB04`), 2 GB |
| **Before RAID** | `/dev/sdb`, `/dev/sdc` raw; `/dev/sdd` spare | Not created | System disk `/dev/sda` only |
| **Healthy** | `/dev/sdb1` + `/dev/sdc1` | `[2/2] [UU]` (`clean`) | `/dev/md0` (`ext4`) mounted at `/mnt/raid1` |
| **Degraded** | `/dev/sdb1` active; `/dev/sdc1` faulty | `[2/1] [U_]` (`degraded`) | `test.txt` readable, checksum intact |
| **Rebuilt** | `/dev/sdb1` + `/dev/sdd1` | `[2/2] [UU]` (`clean`) | Array recovered, checksum verified |

---

## Result

The Windows volume was initialized as GPT and mounted cleanly as `E:`, while the Linux RAID 1 array survived a single-disk failure without data loss or corruption. Both SHA-256 checksums of `test.txt` before and after the failure matched identically (`bb2768263f1b94e287439d0116f928479a749e44bae1970d8a0dafa879d7e7d6`), and the array successfully rebuilt onto `/dev/sdd1`.

---

## RAID 1 versus backup

No, RAID 1 will not help recover a file that a colleague accidentally deleted an hour ago. Because RAID 1 mirrors all block-level write operations in real time, deleting a file immediately removes it from both disks in the array simultaneously. RAID 1 only protects against physical hardware failure of a single drive, whereas recovering deleted files or previous versions requires proper backups or filesystem snapshots.

---

## Troubleshooting & Notes

* **VM Unresponsiveness:** Ubuntu briefly froze during initial disk preparation; I rebooted the guest and re-verified partition tables before proceeding.
* **Device Naming Typo:** I initially passed `/dev/sdb2` instead of `/dev/sdb1` to `mdadm --create`, which failed with a missing device error until corrected.
* **Flag Syntax Error:** When adding the replacement drive, I typed `-add` instead of `--add`, triggering a syntax error that was resolved by using the double-dash flag.
* **Evidence Collection:** Used SSH from Windows PowerShell (`ssh -p 2222 vita@127.0.0.1`) and `Compare-Object` to capture command outputs directly into the host repository and verify checksum integrity.

---

## Evidence

- [evidence/windows-disk-management.png](evidence/windows-disk-management.png) — Disk Management screenshot showing Disk 1 initialized as GPT with volume `LAB04 (E:)` formatted as NTFS.
- [evidence/windows-partition.txt](evidence/windows-partition.txt) — PowerShell output verifying disk number, GPT partition style, drive letter `E:`, and volume health status.
- [evidence/lsblk-before.txt](evidence/lsblk-before.txt) — Ubuntu block device layout prior to partitioning and RAID assembly.
- [evidence/array-healthy.txt](evidence/array-healthy.txt) — Output of `/proc/mdstat` and `mdadm --detail` showing active `[2/2] [UU]` mirror.
- [evidence/checksum-before.txt](evidence/checksum-before.txt) — SHA-256 hash of `test.txt` recorded before simulating disk failure.
- [evidence/array-degraded.txt](evidence/array-degraded.txt) — Array status after failing `/dev/sdc1` (`[2/1] [U_]`).
- [evidence/checksum-after-failure.txt](evidence/checksum-after-failure.txt) — Post-failure SHA-256 hash confirming data integrity.
- [evidence/array-rebuilt.txt](evidence/array-rebuilt.txt) — Final `mdadm` and `lsblk` state showing completed rebuild with `/dev/sdd1`.
