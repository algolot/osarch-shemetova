# Lab 1 — Your first virtual machine

Pair: shemetova / shemetova   Driver first half: shemetova
Machine: Windows 11 Pro (AMD Ryzen 7 7435HS, 24 GB RAM, 512 GB SSD), guest Ubuntu Server 26.04.1 LTS
Date: 19.10.2026

## What I did
1. Installed Oracle VirtualBox Version 7.2.20 r175154 (Qt6.8.0 on windows). Licence (https://www.virtualbox.org/wiki/VirtualBox_PUEL)
2. Created VM lab01-ubuntu: 2 vCPU, 2 GB RAM, 25 GB dynamic disk, NAT.
3. Installed Ubuntu Server, took snapshot clean-install.
4. Broke it: <br>cat /etc/hostname <br>sudo rm /etc/hostname
5. Rolled back to clean-install: <br>cat /etc/hostname <br>sudo reboot 

## Resource justification
I gave the virtual machine 2 vCPU cores and 2 GB of RAM out of my host's 16 threads and 24 GB of RAM. This leaves plenty of resources for my Windows host to run smoothly while idle, and keeps enough headroom to spin up a second guest machine in Lab 2 without overloading the system. Also it allows me to save resources for my personal use like videogames and 4 open browsers

## Result
The VM boots; the break-and-rollback cycle is shown in the evidence below.

## What did not work the first time
- When I first tried to pull the release info out of the VM using SSH from PowerShell, I ran into an authentication issue with `Permission denied`. It turned out I had a small typo with the user profile context
- Also when i tried to break the machine i had to run the commands several times because of typos (i miss the ctrl+c ctrl+v)

## Evidence
- [labs/lab01/evidence/vm-settings1.png](evidence/vm-settings1.png)  — CPU & memory as configured
- [labs/lab01/evidence/vm-settings2.png](evidence/vm-settings2.png)) — disk as configured
- [labs/lab01/evidence/guest-release.txt](evidence/guest-release.txt)) — Ubuntu Server is running in the guest
- [labs/lab01/evidence/broken.png](evidence/broken.png)) — the guest in its broken state
- [labs/lab01/evidence/snapshot-list.png](evidence/snapshot-list.png)) — the snapshot, after the rollback
