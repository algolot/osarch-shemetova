# Lab 0 — Inventory your own machine
Pair: Shemetova / Shemetova Driver first half: Shemetova
Machine: Windows 11
Date: 08.10.2026
## What I did
ran sesveral commands through the PowerShell

## Result

| what | value | where |
| :--- | :--- | :--- |
| **CPU model** | AMD Ryzen 7 7435HS | (Get-CimInstance -ClassName Win32_Processor).Name |
| **core count** | 8 | (Get-CimInstance -ClassName Win32_Processor).NumberOfCores |
| **thread count** | 16 | (Get-CimInstance -ClassName Win32_Processor).ThreadCount |
| **total memory** | 23.6921005249023 | (Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB |
| **the number of installed modules** | 90 | (Get-Module -ListAvailable).Count |
| **speed** | Days              : 0 <br>Hours             : 0 <br>Minutes           : 0 <br>Seconds           : 0 <br>Milliseconds      : 131 <br>Ticks             : 1311400 <br>TotalDays         :1.51782407407407E-06 <br>TotalHours        : 3.64277777777778E-05 <br>TotalMinutes      : 0.00218566666666667 <br>TotalSeconds      : 0.13114 <br>TotalMilliseconds : 131.14| (Measure-Command { Import-Module NameOfModule } |
| **disk model** | Micron MTFDKCD512QFM-1BD1AABLA | (Get-PhysicalDisk).FriendlyName |
| **disk type** | SSD / NVMe | (Get-PhysicalDisk).MediaType + " / " + (Get-Disk).BusType |
| **free space on the volume** | 73.62 | [math]::Round((Get-Volume -DriveLetter C).SizeRemaining / 1GB, 2) |
| **firmware type** | Uefi | (Get-ComputerInfo).BiosFirmwareType |
| **version** | 10.0.26200 | (Get-CimInstance Win32_OperatingSystem).Version |
| **date** | Wednesday, July 31, 2024 5:00:00 AM | (Get-CimInstance Win32_BIOS).ReleaseDate |
| **hardware virtualization** | True | (Get-CimInstance Win32_Processor).VirtualizationFirmwareEnabled |

## What did not work the first time
At first I tried to complete the task through the cmd but wmic was depricated on my windows vesrion

## Evidence
- [labs/lab00-inventory/evidence/CPU] (https://github.com/algolot/osarch-shemetova/blob/84d6ef7dcf6b1cf4da25665760a27972859825d2/labs/lab00-inventory/evidence/CPU) - Evidence source proves that the CPU model is AMD Ryzen 7 7435HS with 8 cores and 16 threads.
- [labs/lab00-inventory/evidence/memory] (https://github.com/algolot/osarch-shemetova/blob/466909c4a73ff76f2764d8a07b73ba90912bfd02/labs/lab00-inventory/evidence/memory) - Evidence source proves that the total physical memory is approximately 23.69 GB.
- [labs/lab00-inventory/evidence/disk] (https://github.com/algolot/osarch-shemetova/blob/466909c4a73ff76f2764d8a07b73ba90912bfd02/labs/lab00-inventory/evidence/disk) - Evidence source proves that the disk is a Micron MTFDKCD512QFM-1BD1AABLA NVMe SSD with 72.89 GB of free space remaining on volume C:.
- [labs/lab00-inventory/evidence/firmware] (https://github.com/algolot/osarch-shemetova/blob/466909c4a73ff76f2764d8a07b73ba90912bfd02/labs/lab00-inventory/evidence/firmware) - Evidence source proves that the firmware type is UEFI, running on OS version 10.0.26200 with a BIOS release date of July 31, 2024.
- [labs/lab00-inventory/evidence/hardware virtualization] (https://github.com/algolot/osarch-shemetova/blob/466909c4a73ff76f2764d8a07b73ba90912bfd02/labs/lab00-inventory/evidence/hardware%20virtualization) - Evidence source proves that hardware virtualization firmware is present and enabled (True).



