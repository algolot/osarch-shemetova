# Lab 6 — Live processes and memory pressure

Pair: <name> + <name> · Date: <date> · Guests: <Ubuntu version / Windows edition, RAM of each>

## Part 1 — One process, three tools
Process chosen: <name> — why: <one sentence>
## Part 1 — One Process, Three Tools

I examined a Python process on Windows 11 and Ubuntu Server
26.04.1 LTS using Task Manager, Process Explorer, and htop.

The same Python command was used on both operating systems:

python -c "import time; data = bytearray(50 * 1024 * 1024); print('Process started'); time.sleep(600)"

| Parameter | Task Manager (Windows) | Process Explorer (Windows) | htop (Ubuntu) |
|---|---|---|---|
| Process | python.exe | python.exe | python3 |
| PID | 47580 | 47580 | 2476 |
| PPID | Not displayed | 29592 (powershell.exe) | 2309 |
| CPU usage | 0% | 0% | 0.0% |
| Physical memory | 54,780 K (Private Working Set) | 62,312 K (Working Set) | 61,300 KiB (RES) |
| Private memory | 54,780 K (Private Working Set) | 56,500 K (Private Bytes) | Not directly displayed |
| Shared memory | Not displayed | 7,528 K (WS Shared) | 7,000 KiB (SHR) |
| Handles | 78 | 78 | Not directly displayed |
| Threads | 1 | 1 | Not displayed |
| Virtual memory | Not displayed | 4,312,700 K (Virtual Size) | 69,896 KiB (VIRT) |
| Process state | Running | Not recorded | Sleeping (S) |


### Where the tools disagree

1. **Virtual memory:** Process Explorer reports 4,312,700 K,
while htop reports 69,896 KiB. The values differ because
Windows and Linux use different virtual memory management
systems and address space layouts.

2. **Physical memory:** Process Explorer reports 62,312 K
(Working Set), while htop reports 61,300 KiB (RES).
Both measure resident physical memory, but the values differ
because the processes run on different operating systems
with different Python versions and memory management methods.

3. **Private memory:** Task Manager reports 54,780 K
(Private Working Set), while Process Explorer reports
56,500 K (Private Bytes). Task Manager measures private
physical memory currently in RAM, while Process Explorer
measures committed private memory, which may include pages
not currently resident in RAM.


## Part 2 — Memory pressure
Guest RAM: 956 MiB · Swap: 0 B
Steps: 
1. Checked the initial memory status:

   `free -h`

2. Checked whether swap was enabled:

   `swapon --show`

   The command returned no output, confirming that no swap was active.

3. Checked the installed stress-ng version:

   `stress-ng --version`

   Version: 0.20.01

4. Started the first memory stress test with 256 MiB:

   `stress-ng --vm 1 --vm-bytes 256M --vm-keep --timeout 30s --metrics-brief`

5. Checked memory usage during and after the test:

   `free -h`

6. Checked kernel logs for OOM events:

   `sudo journalctl -k -b --no-pager | grep -Ei 'out of memory|oom-killer|killed process'`

   No matching events were found.

7. Increased the memory pressure to 512 MiB:

   `stress-ng --vm 1 --vm-bytes 512M --vm-keep --timeout 30s --metrics-brief`

8. Checked memory usage during and after the second test:

   `free -h`

9. Checked the kernel logs again:

   `sudo journalctl -k -b --no-pager | grep -Ei 'out of memory|oom-killer|killed process'`

   No matching OOM events were found.

10. Verified cgroup support:

    `stat -fc %T /sys/fs/cgroup`

    Result: cgroup2fs

11. Checked the systemd version:

    `systemd-run --version`

    Version: 259

12. Started a controlled OOM experiment using a cgroup memory limit:

    `sudo systemd-run --scope -p MemoryMax=128M -p OOMPolicy=continue stress-ng --vm 1 --vm-bytes 256M --vm-keep --oomable --timeout 15s`

13. Checked the kernel logs for OOM events:

    `sudo journalctl -k -b --no-pager | grep -Ei 'oom|out of memory|killed process|memory cgroup'`

14. Checked systemd logs for the test:

    `sudo journalctl -b --no-pager -u run-p1826-i956.scope`

15. Checked memory usage after the OOM experiment:

    `free -h`


| | Before | During (256 MiB) | During (512 MiB — worst) | After |
|---|---|---|---|---|
| Total RAM | 956 MiB | 956 MiB | 956 MiB | 956 MiB |
| Used RAM | 214 MiB | 481 MiB | 723 MiB | 211 MiB |
| Free RAM | 420 MiB | 130 MiB | 11 MiB | 588 MiB |
| Available RAM | 741 MiB | 474 MiB | 232 MiB | 744 MiB |
| Buff/cache | 342 MiB | 365 MiB | 242 MiB | 177 MiB |
| Swap used | 0 B | 0 B | 0 B | 0 B |

What happened: 

- During the first test, stress-ng allocated approximately 256 MiB of memory. Used RAM increased from 214 MiB to 481 MiB, while available RAM decreased from 741 MiB to 474 MiB.

- The test completed successfully in 30.12 seconds with no failures.

- During the second test, stress-ng allocated approximately 512 MiB. Used RAM increased to 723 MiB, and free RAM dropped to only 11 MiB.

- However, the system still had 232 MiB of available memory because Linux could reclaim some memory from its cache.

- The second test completed successfully in 30.25 seconds without triggering the OOM Killer.

- After the test, available RAM returned to 744 MiB.

- Both tests completed successfully, and no OOM events were found in the kernel logs.

- For the final experiment, I used systemd-run to limit the test process group to 128 MiB while requesting a 256 MiB allocation.

- The stress-ng worker terminated prematurely after approximately 0.68 seconds.

- The kernel logs confirmed that the Linux OOM Killer terminated the stress-ng-vm process because it exceeded the cgroup memory limit.

- The Ubuntu VM remained operational, and available RAM returned to 746 MiB after the experiment.

### What the kernel did
- The Linux kernel detected that the stress-ng process exceeded its assigned cgroup memory limit and invoked the OOM Killer.

- The kernel log reported:

`Nov 20 09:01:06 lab01-ubuntu kernel: stress-ng-vm invoked oom-killer: gfp_mask=0xcc0(GFP_KERNEL), order=0, oom_score_adj=1000`

- The log also identified the type of memory exhaustion:

`Nov 20 09:01:06 lab01-ubuntu kernel: oom-kill:constraint=CONSTRAINT_MEMCG,nodemask=(null),cpuset=/,mems_allowed=0,oom_memcg=/system.slice/run-p1826-i956.scope,task_memcg=/system.slice/run-p1826-i956.scope,task=stress-ng-vm,pid=1829,uid=0`

- The most important line was:

`Nov 20 09:01:06 lab01-ubuntu kernel: Memory cgroup out of memory: Killed process 1829 (stress-ng-vm) total-vm:308372kB, anon-rss:129948kB, file-rss:1092kB, shmem-rss:64kB, UID:0 pgtables:344kB oom_score_adj:1000`

- The systemd log confirmed:

`Nov 20 09:01:06 lab01-ubuntu systemd[1]: run-p1826-i956.scope: The kernel OOM killer killed some processes in this unit.`

- It also reported:

`Nov 20 09:01:06 lab01-ubuntu systemd[1]: run-p1826-i956.scope: Consumed 197ms CPU time over 210ms wall clock time, 128M memory peak.`

- The OOM event occurred on November 20, 2026, at 09:01:06, according to the Ubuntu system clock.

- The kernel terminated stress-ng-vm (PID 1829) because the process group exceeded its 128 MiB memory limit.

- The kernel reported `CONSTRAINT_MEMCG`, confirming that this was a memory cgroup OOM event rather than system-wide memory exhaustion.

- This demonstrated how Linux can terminate a process that exceeds its assigned memory limit while allowing the rest of the system to continue operating.


### Windows
- I checked the Windows System event log on my Windows 11 Pro host using PowerShell.

Command:

```powershell
Get-WinEvent -FilterHashtable @{
    LogName = 'System'
    ProviderName = 'Microsoft-Windows-Resource-Exhaustion-Detector'
} -MaxEvents 10 | Format-List TimeCreated, Id, Message
```
- Get-WinEvent : Не удалось найти события, соответствующие указанному условию выбора.

- PowerShell returned a NoMatchingEventsFound error, indicating that no events from Microsoft-Windows-Resource-Exhaustion-Detector were found in the available System event log.

- Unlike Ubuntu, where I deliberately triggered an OOM event, I did not perform a memory exhaustion test on Windows.

- Therefore, no Windows memory exhaustion event was observed.

- The absence of events does not mean that Windows cannot experience memory pressure. It only means that no matching events were recorded in the available log.

## What did not work the first time
- During Part 1, I initially monitored two different executions of the Python process in Windows Task Manager and Process Explorer.


## Evidence

- [evidence/task-manager.png](evidence/task-manager.png) — Windows Task Manager screenshot showing the Python process (PID 47580), CPU usage, private working set (54,780 K), handles (78), and threads (1).
- [evidence/process-explorer.png](evidence/process-explorer.png) — Process Explorer screenshot showing the same Python process (PID 47580), parent process `powershell.exe`, Private Bytes (56,500 K), Working Set (62,312 K), handles (78), and threads (1).
- [evidence/htop.png](evidence/htop.png) — Ubuntu htop screenshot showing the Python process (PID 2476), PPID (2309), virtual memory (VIRT), resident memory (RES), shared memory (SHR), and CPU usage.
- [evidence/memory-pressure.txt](evidence/memory-pressure.txt) — Raw outputs of `free -h` and `stress-ng` showing memory usage before, during, and after the 256 MiB and 512 MiB stress tests, followed by the controlled OOM experiment.
- [evidence/kernel-log-extract.txt](evidence/kernel-log-extract.txt) — Raw kernel and systemd logs confirming that the Linux OOM Killer terminated `stress-ng-vm` (PID 1829) after exceeding the 128 MiB cgroup memory limit.
- [evidence/windows-memory-events.txt](evidence/windows-memory-events.txt) — PowerShell output of `Get-WinEvent` showing that no memory resource exhaustion events were found in the Windows System event log.




