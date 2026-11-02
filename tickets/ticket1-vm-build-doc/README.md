# Ticket 1 — “New developer starts Monday, needs a test machine”

## 1. What was asked

"From: Aigerim T. (Office Manager)
Subject: test machine for new dev
Hi, we have someone starting on Monday and he needs a test computer
set up. Nothing special, just so he can try things without breaking
anything. Can you write down how to do it so I can do the next one
myself? Thanks"

## 2. What was actually needed

- **What the request left out:** 
  - The request did not specify which operating systems are required (Linux, Windows, or both).
  - No hardware resource details (host RAM, free disk space, CPU cores) or target VM allocations (memory, disk size) were provided.
  - Network requirements (internet access, guest-to-guest communication, or local network integration) were omitted.
  - No mention of software tools, desktop environments, or automated/manual setup preferences.
- **Where the request is wrong:** 
  - The request implies that a single "test computer" can be set up arbitrarily ("nothing special"), whereas a professional development environment typically requires both a Linux environment (for standard server/dev tasks) and a Windows environment (for platform-specific compatibility testing). Furthermore, it treats a hypervisor build process as a simple one-off task without documenting the configuration choices needed for reproducibility.
- **What I would have asked the requester:**
  - Which operating system distributions and versions does the new developer need?
  - What are the performance and resource constraints of the host machine?
  - Will the guest machines need to interact with each other or external services?
- **What I assumed instead of an answer:**
  - I assumed we need a dual-guest environment consisting of **Ubuntu Linux** and **Windows 11 Enterprise Evaluation** to cover multi-platform development and testing needs.
  - I assumed standard conservative resource allocations (4 GB RAM and 2 CPU cores per VM, with a 25 GB virtual disk) to fit comfortably within typical host limitations while keeping the host responsive.
  - I assumed a shared VirtualBox **NAT Network** configuration so both guests can access the internet and communicate directly with each other without violating physical campus network filtering rules.
 
**Resource Calculations (Host Memory and Disk)**
- Host Specifications: The host machine operates with 24,576 MB (~24 GB) of total system RAM and 16 logical processor cores.
- Ubuntu VM Allocation: Allocated 4,096 MB RAM (~16.6% of host RAM) and 2 virtual CPUs (12.5% of host logical cores).
- Windows VM Allocation: Allocated 4,096 MB RAM (~16.6% of host RAM) and 2 virtual CPUs (12.5% of host logical cores).
- Simultaneous Running Impact: If both guests run at the same time, their combined memory usage is 8,192 MB (~8 GB, or ~33.3% of total host RAM). This leaves ~16,384 MB (~16 GB) of RAM free for the host OS and user applications, preventing performance degradation or swapping on the host.
- Disk Space Impact: Both VMs use 25 GB VirtualBox Disk Image (VDI) drives with dynamic allocation enabled ("Pre-allocate Full Size" unchecked). The initial footprint on the host SSD is only a few gigabytes per guest, with maximum host storage usage capped at 50 GB as the drives expand.

**Non-Default Settings Table**
*Below is a breakdown of every virtual machine setting that differs from the VirtualBox default profile, along with the technical justification:*
| Setting Area | valueVirtualBox Default | Configured Setting | Reason/Justification |
| :--- | :--- | :--- |
| Unattended Install | Checked (Auto-install) | Unchecked (Manual setup) | Manual installation allows full control and explanation of installer prompts for documentation |
| Base Memory (RAM)	| 2048 MB (Linux) / 4096 MB (Win) |	4096 MB for both VMs | Ensures usable GUI performance during labs without starving the 24 GB host system |
| Processor Cores |	1 CPU Core | 2 CPUs for both VMs	| Prevents OS lag during compilation and package installation while using < 25% host cores |
| Network Adapter |	NAT |	NAT Network |	Standard NAT isolates guests from each other. NAT Network allows inter-guest pinging and internet access behind host MAC filters |
| Windows EFI & TPM 2.0 |	Default/Variable |	Enabled (EFI & TPM 2.0) |	Required by Windows 11 setup requirements to install properly without breaking security constraints |
| Windows Defender Firewall |	Inbound ICMP Blocked |	Custom ICMPv4 Inbound Rule |	Enables ping diagnostic checks without dangerously turning off the firewall entirely |

## 3. What I did

1. **Prepared Virtual Machines:** Created two separate virtual machines (`lab01-ubuntu` and `lab02-windows`) in Oracle VirtualBox following manual configuration steps rather than unattended installation to maintain full control over each installer choice.
2. **Allocated Resources:** Assigned 4 GB of RAM and 2 CPU cores to each virtual machine, along with 25 GB dynamically allocated VDI virtual hard disks, balancing performance and host resource availability.
3. **Configured Networking:** Set up a shared VirtualBox **NAT Network** with DHCP enabled for both adapters, ensuring both guests obtained internal IP addresses, internet access, and mutual visibility.
4. **Verified Systems & Internet:** Started both VMs, used SSH with port forwarding (port 2222) to capture Linux system info (`uname-result.txt`), and ran system checks (`systeminfo`, `ipconfig`, and ping tests) on Windows.
5. **Configured Firewall & Inter-Guest Communication:** Tested guest-to-guest connectivity. Because Windows Defender Firewall blocks incoming ICMP echo requests by default on "Public" network profiles, I added a specific targeted inbound rule (`New-NetFirewallRule`) for ICMPv4 instead of dangerously disabling the entire firewall.
6. **Created Recovery Snapshots:** Shut down both guests and took clean-installation snapshots (`Ubuntu - Clean Installation` and `Windows - Clean Installation`) to allow quick recovery if future testing breaks the configuration.

## 4. What I would do differently

- **Disk Sizing for Windows:** While a 25 GB virtual disk is adequate for a basic initial setup and lightweight testing, 25 GB fills up rapidly under Windows 11 once operating system updates, visual studio tools, and dependencies are installed. Next time, I would allocate a larger virtual disk (e.g. 64 GB or 80 GB) for the Windows guest to avoid running out of storage space prematurely

## 5. Evidence

- [tickets/ticket1-vm-build-doc/evidence/01-new-vm-wizard-ubuntu.png](evidence/01-new-vm-wizard-ubuntu.png) — Proves the initial Ubuntu VM creation wizard parameters and manual setup selection.
- [tickets/ticket1-vm-build-doc/evidence/01-new-vm-wizard-windows.png](evidence/01-new-vm-wizard-windows.png) — Proves the initial Windows VM configuration and hardware settings.
- [tickets/ticket1-vm-build-doc/evidence/02-disk-settings-ubuntu.png](evidence/02-disk-settings-ubuntu.jpg) — Shows the 25 GB dynamic VDI virtual disk configuration for Ubuntu.
- [tickets/ticket1-vm-build-doc/evidence/02-disk-settings-windows.png](evidence/02-disk-settings-windows.png) — Shows the virtual hard disk allocation settings for Windows.
- [tickets/ticket1-vm-build-doc/evidence/02-vm-hardware-ubuntu.png](evidence/02-vm-hardware-ubuntu.png) — Shows the CPU & memory as configured for ubuntu.
- [tickets/ticket1-vm-build-doc/evidence/02-vm-hardware-windows.png](evidence/02-vm-hardware-windows.png) — Shows the CPU & memory as configured for windows.
- [tickets/ticket1-vm-build-doc/evidence/03-network-adapter-ubuntu.png](evidence/03-network-adapter-ubuntu.png) — Confirms the Ubuntu network adapter is attached to the shared NAT Network.
- [tickets/ticket1-vm-build-doc/evidence/03-network-adapter-windows.png](evidence/03-network-adapter-windows.png) — Confirms the Windows network adapter uses the same NAT Network.
- [tickets/ticket1-vm-build-doc/evidence/04-guest-uname-ubuntu.txt](evidence/04-guest-uname-ubuntu.txt) — Contains the remote SSH command output verifying the Ubuntu kernel and release version.
- [tickets/ticket1-vm-build-doc/evidence/04-system-info-windows.txt](evidence/04-system-info-windows.txt) — Proves the Windows network configuration and active IPv4 address assignment.
- [tickets/ticket1-vm-build-doc/evidence/05-ping-between-guests.txt](evidence/05-ping-between-guests.txt) — Documents successful bidirectional ping results (Ubuntu ⇄ Windows and both to the internet) with 0% packet loss.
- [tickets/ticket1-vm-build-doc/evidence/06-snapshot-list-ubuntu.png](evidence/06-snapshot-list-ubuntu.png) — Proves the creation of the clean-install recovery snapshot for the Ubuntu VM.
- [tickets/ticket1-vm-build-doc/evidence/06-snapshot-list-windows.png](evidence/06-snapshot-list-windows.png) — Proves the creation of the clean-install recovery snapshot for the Windows VM.
