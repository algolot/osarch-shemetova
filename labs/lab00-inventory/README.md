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
| **the number of installed modules** | DeviceLocator Size (GB) Speed Manufacturer<br>------------- --------- ----- ------------<br>DIMM 0               12  4800 Ramaxel Technology<br>DIMM 0               12  4800 Ramaxel Technology | Get-CimInstance Win32_PhysicalMemory | Select-Object DeviceLocator, @{Name="Size (GB)";Expression={$_.Capacity / 1GB}}, Speed, Manufacturer |
| **speed** | DeviceLocator    Capacity Speed <br>-------------    -------- ----- <br>DIMM 0        12884901888  4800 <br>DIMM 0        12884901888  4800| Get-CimInstance -ClassName Win32_PhysicalMemory | Format-Table DeviceLocator, Capacity, Speed |
| **disk model** | Micron MTFDKCD512QFM-1BD1AABLA | (Get-PhysicalDisk).FriendlyName |
| **disk type** | SSD / NVMe | (Get-PhysicalDisk).MediaType + " / " + (Get-Disk).BusType |
| **free space on the volume** | 73.62 | [math]::Round((Get-Volume -DriveLetter C).SizeRemaining / 1GB, 2) |
| **firmware type** | Uefi | (Get-ComputerInfo).BiosFirmwareType |
| **version** | PQCN12WW | (Get-CimInstance Win32_BIOS).SMBIOSBIOSVersion |
| **date** | Wednesday, July 31, 2024 5:00:00 AM | (Get-CimInstance Win32_BIOS).ReleaseDate |
| **hardware virtualization** | True | (Get-CimInstance Win32_Processor).VirtualizationFirmwareEnabled |

## What did not work the first time
- At first I tried to complete the task through the cmd but wmic was depricated on my windows vesrion
- i used < Measure-Command { Import-Module NameOfModule }> to find the speed of the installed modules at first and it outputed an errror + some outout that didn't give the speed
  Import-Module : Указанный модуль "NameOfModule" не был загружен, так как ни в одном из каталогов
модулей не был обнаружен действительный файл модуля.
строка:1 знак:19
+ Measure-Command { Import-Module NameOfModule }
+                   ~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : ResourceUnavailable: (NameOfModule:String) [Import-Module], FileNotFou
   ndException
    + FullyQualifiedErrorId : Modules_ModuleNotFound,Microsoft.PowerShell.Commands.ImportModuleComma
   nd


Days              : 0
Hours             : 0
Minutes           : 0
Seconds           : 0
Milliseconds      : 44
Ticks             : 446160
TotalDays         : 5.16388888888889E-07
TotalHours        : 1.23933333333333E-05
TotalMinutes      : 0.0007436
TotalSeconds      : 0.044616
TotalMilliseconds : 44.616


- RAM Module Count: Initially used (Get-Module -ListAvailable).Count, which incorrectly counted installed PowerShell modules instead of physical hardware. This was corrected by querying Get-CimInstance Win32_PhysicalMemory to accurately capture the 2 x 12 GB stick configuration.

- BIOS / System Identification: Originally relied on Win32_OperatingSystem.Version, which returned the Windows OS build rather than hardware firmware. This was corrected by using (Get-CimInstance Win32_BIOS).SMBIOSBIOSVersion to properly pull the low-level BIOS version.

## Evidence
- [labs/lab00-inventory/evidence/CPU.txt] (https://github.com/algolot/osarch-shemetova/blob/84d6ef7dcf6b1cf4da25665760a27972859825d2/labs/lab00-inventory/evidence/CPU.txt) - Evidence source proves that the CPU model is AMD Ryzen 7 7435HS with 8 cores and 16 threads.
- [labs/lab00-inventory/evidence/memory.txt] (https://github.com/algolot/osarch-shemetova/blob/466909c4a73ff76f2764d8a07b73ba90912bfd02/labs/lab00-inventory/evidence/memory.txt) - Evidence source proves that the total physical memory is approximately 23.69 GB.
- [labs/lab00-inventory/evidence/disk.txt] (https://github.com/algolot/osarch-shemetova/blob/466909c4a73ff76f2764d8a07b73ba90912bfd02/labs/lab00-inventory/evidence/disk.txt) - Evidence source proves that the disk is a Micron MTFDKCD512QFM-1BD1AABLA NVMe SSD with 72.89 GB of free space remaining on volume C:.
- [labs/lab00-inventory/evidence/firmware.txt] (https://github.com/algolot/osarch-shemetova/blob/466909c4a73ff76f2764d8a07b73ba90912bfd02/labs/lab00-inventory/evidence/firmware.txt) - Evidence source proves that the firmware type is UEFI, running on OS version 10.0.26200 with a BIOS release date of July 31, 2024.
- [labs/lab00-inventory/evidence/hardware virtualization.txt] (https://github.com/algolot/osarch-shemetova/blob/466909c4a73ff76f2764d8a07b73ba90912bfd02/labs/lab00-inventory/evidence/hardware%20virtualization.txt) - Evidence source proves that hardware virtualization firmware is present and enabled (True).

