##Step 1. Creating Ubuntu and Windows Virtual Machines

Ubuntu VM
1. Open Oracle VirtualBox.
2. Click New to open the New Virtual Machine wizard.
3. Enter lab01-ubuntu as the VM name. Leave the VM folder at its default location unless that disk has insufficient free space.
4. Under ISO Image, browse to and select the Ubuntu 26.04 LTS ISO file.
5. Set OS to Linux and OS Version to Ubuntu (64-bit).
6. Uncheck Proceed with Unattended Installation so that you can follow the installer manually.
7. Keep the wizard open for the hardware and disk settings in Steps 2–3.

[tickets/ticket1-vm-build-doc/evidence/01-new-vm-wizard-ubuntu.png](evidence/01-new-vm-wizard-ubuntu.png)

Why: Ubuntu LTS provides a Linux environment for development and testing. Using the Ubuntu (64-bit) profile gives VirtualBox suitable starting defaults. Manual installation makes the process easier to explain and reproduce.

Windows VM
1. In the main VirtualBox window, click New again.
2. Enter lab02-windows as the VM name.
3. Select the Windows 11 Enterprise Evaluation (x64) ISO file.
4. Set OS to Microsoft Windows and OS Version to Windows 11 (64-bit).
5. Uncheck Proceed with Unattended Installation.
6. Continue with Steps 2–3 for its hardware and disk configuration.

[tickets/ticket1-vm-build-doc/evidence/01-new-vm-wizard-windows.png](evidence/01-new-vm-wizard-windows.png)

Why: Windows provides a second operating-system environment for checking whether software behaves differently from Linux. The Enterprise Evaluation edition is intended for testing rather than permanent production use. Manual installation allows the user to verify each installer choice.

##Step 2. Allocating RAM and CPU

For Ubuntu VM:
1. Expand the "Specify Virtual Hardware" section.
2. Set Base Memory to 4096 MB (4 GB).
3. Set the Number of CPUs to 2.
4. Leave the remaining settings at their defaults.

[tickets/ticket1-vm-build-doc/evidence/02-disk-settings-ubuntu.png](evidence/02-disk-settings-ubuntu.jpg)

For Windows VM:
1. Expand the "Specify Virtual Hardware" section.
2. Set Base Memory to 4096 MB (4 GB).
3. Set the Number of CPUs to 2.
4. Leave the remaining settings at their defaults.

[tickets/ticket1-vm-build-doc/evidence/02-disk-settings-windows.png](evidence/02-disk-settings-windows.png)

Why: Both virtual machines were allocated 4 GB of RAM and 2 CPU cores to provide sufficient resources for basic operating system tasks and software testing. These settings balance performance and resource usage, allowing the host computer to remain responsive. Using the same hardware configuration also makes it easier to compare the two operating systems.


##Step 3. Creating the Virtual Hard Disks

For Ubuntu VM:
1. Expand the "Specify Virtual Hard Disk" section.
2. Select "Create a New Virtual Hard Disk".
3. Set the disk size to 25 GB.
4. Select VDI (VirtualBox Disk Image) as the disk format.
5. Leave "Pre-allocate Full Size" unchecked.
6. Continue with the virtual machine creation.

[tickets/ticket1-vm-build-doc/evidence/02-vm-hardware-ubuntu.png](evidence/02-vm-hardware-ubuntu.png)

For Windows VM:
1. Expand the "Specify Virtual Hard Disk" section.
2. Select "Create a New Virtual Hard Disk"
3. Set the disk size to 25 GB.
4. Select VDI (VirtualBox Disk Image) as the disk format.
5. Leave "Pre-allocate Full Size" unchecked.
6. Continue with the virtual machine creation.

[tickets/ticket1-vm-build-doc/evidence/02-vm-hardware-windows.png](evidence/02-vm-hardware-windows.png)

Why: Both virtual machines were assigned 25 GB of virtual disk space to minimize storage consumption on the host computer. The VDI format was selected because it is the native disk format of VirtualBox. Full-size preallocation was disabled so that the virtual disk files grow as data is added, rather than immediately occupying the entire allocated space.

Note: While 25 GB may be sufficient for a minimal Ubuntu installation, it is below the recommended storage requirement for Windows 11. A larger virtual disk would be preferable for Windows to accommodate updates and additional software.


##Step 4. Installing the operating systems
Ubuntu installation
1. Select lab01-ubuntu in VirtualBox and click Start.
2. When the Ubuntu installer appears, choose Install Ubuntu (or Try or Install Ubuntu, then Install Ubuntu, depending on the installer screen).
3. Select the appropriate language and keyboard layout.
4. Choose the normal/default installation option for your intended use.
5. When asked where to install Ubuntu, select the virtual disk created in Step 3. If the installer says Erase disk and install Ubuntu, confirm that the selected disk is the VM's 25 GB virtual disk, not your laptop's physical disk.
6. Create a local username and password. Record the username privately; do not publish the password in the repository.
7. Complete installation and restart the VM when prompted. If it asks you to remove installation media, use Devices → Optical Drives in VirtualBox to eject the ISO, then press Enter.
8. Log in and confirm that the Ubuntu desktop opens.

Why: Installing onto the virtual disk keeps test software separate from the physical laptop. A local test account is sufficient for the assignment and avoids exposing real personal credentials.

Windows installation
1. Select lab02-windows and click Start.
2. Follow the Windows Setup screens and select the appropriate language and keyboard settings.
3. Choose the Windows 11 Enterprise Evaluation edition if the installer asks for an edition.
4. For the destination, select the unallocated space on the Windows VM's virtual disk. Do not select or format a disk belonging to the physical host.
5. Complete the installation and restart when required.
6. Follow the first-run setup screens to create the permitted test account and finish privacy/device settings.
7. Log in and confirm that the Windows desktop opens.

Why: A separate Windows guest lets a developer test Windows-specific behavior without modifying the host operating system. The evaluation edition is temporary, so it should not be treated as a permanent licensed workstation.


##Step 5. Network configuration (both VMs)
1. Shut down both virtual machines before changing their network settings.
2. In VirtualBox, open Tools → Network (or Network Manager, depending on the version). Find NAT Networks and create a NAT Network if one does not already exist. Leave DHCP enabled so the guests can receive addresses automatically.
3. Select lab01-ubuntu → Settings → Network → Adapter 1.
4. Check Enable Network Adapter.
5. Set Attached to to NAT Network, and choose the NAT Network created in the previous step.
6. Open Advanced if necessary and confirm Cable Connected is checked. Click OK.
7. Repeat steps 3–6 for lab02-windows, using the same NAT Network.
8. Start both guests.

[tickets/ticket1-vm-build-doc/evidence/03-network-adapter-ubuntu.png](evidence/03-network-adapter-ubuntu.png) 
[tickets/ticket1-vm-build-doc/evidence/03-network-adapter-windows.png](evidence/03-network-adapter-windows.png)

Why: A shared NAT Network gives both guests internet access through the host and allows them to communicate with each other. Unlike a bridged adapter, it does not require the guests to appear as separate machines on the physical teaching network. NAT and NAT Network are different options: two guests on separate default NAT connections usually cannot reach each other directly. A NAT Network is not a security sandbox against all network threats, so use only disposable test data.


##Step 6. Checking the installed systems and internet access
Ubuntu
1. In Ubuntu, ensure SSH is available or use the VirtualBox console. To collect evidence remotely from the host via SSH (using port forwarding configured on port 2222), run:

Bash
ssh -p 2222 vita@127.0.0.1 "uname -a; lsb_release -a" > evidence/uname-result.txt

2. Confirm that the command outputs show the Linux kernel version, distribution details, and active IP configuration.

Why: A visible desktop alone does not prove the operating system or networking works. These commands provide reproducible evidence of the Linux version, IP configuration and internet access.

Windows
1. In Windows, open PowerShell (Start → type PowerShell).
2. Run these commands to gather system and network information:

PowerShell
systeminfo
ipconfig
ping ubuntu.com
Confirm that systeminfo identifies Windows, ipconfig shows an IPv4 address, and ping receives replies.

3.Save the results by copying them or redirecting them into your host's evidence folder as 04c-windows-systeminfo.txt and 05c-ipconfig-windows.txt.

Why: This proves that the Windows guest is installed and connected, rather than assuming it is operational just because VirtualBox starts it.


##Step 7. Testing communication between the two guests and fixing the firewall
1.Find both addresses:

On Windows: Open PowerShell and run ipconfig. Note the IPv4 address of the adapter (e.g., 192.168.80.131). Save it using:

PowerShell
ipconfig | Set-Clipboard
Paste the output into evidence/ipconfig-windows.txt.

On Ubuntu: Find the IP address using ip -br a (e.g., 192.168.80.130). Save the output from your host via SSH:

Bash
ssh -p 2222 vita@127.0.0.1 "ip addr" > evidence/ip-addr-linux.txt
Test Windows → Ubuntu:

[tickets/ticket1-vm-build-doc/evidence/04-guest-uname-ubuntu.txt](evidence/04-guest-uname-ubuntu.txt)

2. In PowerShell on Windows, run:

PowerShell
ping <Ubuntu_IP>
Replies come back immediately because Ubuntu's firewall is inactive by default.

[tickets/ticket1-vm-build-doc/evidence/04-system-info-windows.txt](evidence/04-system-info-windows.txt)

3. Test Ubuntu → Windows (and handle the firewall properly):

From Ubuntu, run:

Bash
ssh -p 2222 vita@127.0.0.1 "ping -c 4 <Windows_IP>"
Note: The ping will likely time out initially. Why? Windows Defender Firewall blocks incoming ICMP echo requests by default on networks classified as "Public" (the strictest profile).

4. The correct fix (do not disable the firewall!): Open PowerShell as Administrator on Windows and add a specific inbound rule for ICMPv4:

PowerShell
New-NetFirewallRule -DisplayName "Allow ping in (ICMPv4)" -Protocol ICMPv4 -IcmpType 8 -Direction Inbound -Action Allow
Re-run the ping from Ubuntu — replies will now succeed.

5. Prove internet access and compile all results:

6. Test internet connectivity from both guests (ping -c 4 ubuntu.com on Ubuntu and ping ubuntu.com on Windows).

7. Combine all ping tests into a single evidence file named evidence/ping-both-ways.txt with clear headings for each direction.

Expected result: Ubuntu → Windows, Windows → Ubuntu, Ubuntu → internet, and Windows → internet each return successful replies with 0% packet loss.

[tickets/ticket1-vm-build-doc/evidence/05-ping-between-guests.txt](evidence/05-ping-between-guests.txt) 

Why: Internet access does not automatically mean that two VMs can reach one another. Testing both directions confirms guest-to-guest connectivity, and using a targeted firewall rule ensures security is maintained rather than recklessly disabling protection.

##Step 8. Creating recovery snapshots
Ubuntu
1. Shut down lab01-ubuntu normally from inside Ubuntu.
2. In VirtualBox Manager, select the Ubuntu VM and open Snapshots.
3. Choose Take Snapshot.
4. Name it Ubuntu - Clean Installation and confirm.
5. Check that it appears in the snapshot list.

[tickets/ticket1-vm-build-doc/evidence/06-snapshot-list-ubuntu.png](evidence/06-snapshot-list-ubuntu.png) 

Windows
1. Shut down lab02-windows normally.
2. Select the Windows VM in VirtualBox and open Snapshots.
3. Choose Take Snapshot.
4. Name it Windows - Clean Installation and confirm.
5. Check that it appears in the list.

[tickets/ticket1-vm-build-doc/evidence/06-snapshot-list-windows.png](evidence/06-snapshot-list-windows.png)

Why: A snapshot records a recoverable VM state. If testing damages the guest configuration, the developer can revert to a clean state instead of reinstalling the OS. Snapshots are not a substitute for backups of important files.


##Step 9. Final checks and handover
1. Start both VMs and confirm that each reaches its desktop.
2. Confirm that both can reach the internet and each other using the commands in Steps 6–7.
3. Confirm that a clean-install snapshot exists for each guest.
4. Keep the virtual disks, ISO files and local test credentials under the control of the person responsible for the machines. Do not publish passwords or sensitive test data.
5. In the semester repository, put this guide at tickets/ticket1-vm-build-doc/BUILD.md and all screenshots and command outputs in its evidence/ folder.
6. Open the Markdown file in GitHub and verify that every screenshot displays and that every evidence link works. A new user should be able to follow the guide without guessing about a missing menu or setting.

Why: The handover is complete only when someone else can reproduce the machines and verify that they work. The separate README.md report must still explain the original request, its missing requirements and assumptions, the decisions made, the evidence, one real problem encountered and its resolution, and what could be improved next time.
