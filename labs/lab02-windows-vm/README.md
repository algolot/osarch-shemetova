# Lab 2 — A Windows guest, and a network between them

Pair: shemetova / zadorozhnaya   Driver first half: shemetova
Machine: Windows 11 Pro (AMD Ryzen 7 7435HS, 24 GB RAM, 512 GB SSD), guests Ubuntu Server 26.04.1 LTS + Windows 11 Enterprise eval
Date: <31.10.2026>

## What I did
1. Downloaded Windows 11 Enterprise evaluation. Licence: https://learn.microsoft.com/en-us/windows/iot/iot-enterprise/eula/license_en-us_english_united_states.pdf
2. Created lab02-windows: 2 vCPU, 4 GB, 64 GB thin, UEFI + Secure Boot, vTPM.
3. Network mode: NAT Network (VirtualBox), both guests (`10.0.2.15` for Ubuntu and `10.0.2.3` for Windows). Why: Both guests must be on the same network to communicate with each other, and NAT Network provides a shared private subnet while allowing outgoing internet access.
4. Ping Ubuntu → Windows timed out because Windows Defender Firewall blocks incoming ICMP echo requests (ping) by default on new/Public network profiles. Fixed with: 
   `New-NetFirewallRule -DisplayName "Allow ping in (ICMPv4)" -Protocol ICMPv4 -IcmpType 8 -Direction Inbound -Action Allow`
5. Overcommitment: set 14 GB + 14 GB on a 24 GB host.



## Network diagram
```
              Internet
                 |
      Host laptop (24 GB RAM, AMD Ryzen 7)
                 |
     [VirtualBox NAT Network · 10.0.2.0/24]
          /                        \
lab01-ubuntu                  lab02-windows
(10.0.2.15)                   (10.0.2.3)
```

## Result
| | Before | After |
|---|---|---|
| Host RAM in use | 12,6 GB | 23,2 GB |
| Available | 11,1 GB | 531 MB |
| Committed / Swap used | 20,6/44,7 GB | 47,2/48,3 GB|
| What I noticed | — | high memory pressure (98% usage), when i tried to use browser on host the available memory dropped to 200 MB and the responses were slow |

## What did not work the first time
- Ctrl+C wasn't working for us in the Windows virtual machine because, in Lab 1, I had changed the host key from the right Ctrl to the left Ctrl (since my keyboard doesn't have a right Ctrl key). We fixed this by changing the host key to the right Shift key

## Evidence
- [evidence/ipconfig-windows.txt](evidence/ipconfig-windows.txt) — Windows address
- [evidence/ip-addr-linux.txt](evidence/ip-addr-linux.txt) — Ubuntu address
- [evidence/ping-both-ways.txt](evidence/ping-both-ways.txt) — both directions and the internet
- [evidence/host-memory-before.png](evidence/host-memory-before.png) — host memory, guests off
- [evidence/host-memory-after.png](evidence/host-memory-after.png) — host memory, both guests overcommitted
