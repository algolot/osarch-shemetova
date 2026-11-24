# Ticket 2 - Kitting out the new office

## 1. What was asked

From Daniyar K. (Director): "We are opening the second office and need four computers — accountant, sales, web developer, designer. Budget 3,000,000 tenge for everything. Everyone says we should just buy the same four machines, is that right? Make sure they last a few years. Monitors included."

## 2. What was actually needed

Four identical machines are not the best choice. The four employees have different workloads, so the first resource to run out is different for each of them. The accountant needs reliable storage and Windows for accounting software. The sales manager needs enough RAM to run CRM, Excel and many browser tabs during calls. The web developer needs RAM and fast storage for Docker containers and a local database. The designer needs a dedicated graphics card and a good monitor. Buying four identical PCs would waste money on parts that some employees rarely use, while limiting the employees who need them.

The request also left some things out:

- "Monitors included" does not say whether keyboards, mice, cables, a UPS, delivery or software subscriptions are included. I included monitors and operating systems in the budget. I assumed the office already has keyboards, mice, webcams and backup infrastructure; delivery and any additional cables still need to be confirmed.
- "A few years" is not a specific period, and there is no information about possible upgrades.
- The director did not specify the software used by each employee or whether the company already owns Windows licences.

What I would ask Daniyar:

- Which accounting software is used, and does it require Windows?
- Does the designer work mainly in Photoshop and Illustrator, or also with large Blender projects?
- Are keyboards, mice, cables, a UPS and delivery part of the 3,000,000 KZT?
- How many years should the computers last, and what warranties are needed?

What I assumed instead: the accountant uses 1C and Excel, the sales manager uses a browser-based CRM and Office, the developer can work on Ubuntu, and the designer uses Adobe applications with occasional Blender work. The accountant, sales manager and designer need Windows 11 Pro. I treated "a few years" as approximately 3-5 years. The accountant and sales manager use AM4 and DDR4; the developer and designer use AM5 and DDR5. All four can be upgraded, although the AM5 platform offers more room for future CPU changes.

## 3. What I did

I started with the four roles, described their daily workload, identified the likely bottleneck and chose parts around it (see [builds.md](builds.md)). All computers have at least 16 GB of RAM, a 1 TB SSD, a monitor and a licensed operating system. The office PCs use integrated graphics and 1 TB SATA SSDs to save money. The developer has 32 GB DDR5 and an NVMe SSD, without a separate graphics card. The designer has 32 GB DDR5, an RTX 5060 8 GB and a 27-inch QHD IPS monitor.

I compared component prices from vendors that deliver to Kazakhstan and selected parts based on each employee's workload and the available budget. Every component, its price, source and date are recorded in [budget.csv](budget.csv).

| Role | Total, KZT |
| --- | ---: |
| Accountant | 578,150 |
| Sales manager | 563,150 |
| Web developer | 651,202 |
| Designer | 1,182,207 |
| **Grand total** | **2,974,709** |

The quote is **25,291 KZT under** the 3,000,000 KZT limit. This is a small reserve, so I would confirm availability, quantity and delivery costs before ordering. Memory prices were one of the main reasons I kept 16 GB instead of 32 GB for sales. The board has spare RAM slots, but an additional kit should be checked for compatibility rather than assumed to work at its rated speed.

**Which machine will I upgrade first, in eighteen months?** The sales manager's PC. I would upgrade its RAM from 16 GB to 32 GB if CRM, Excel, 30-40 browser tabs and video calls regularly push memory usage close to its limit. This would reduce paging to the SSD. I would first check actual memory usage during a busy workday, then add a compatible kit or replace the existing one if mixing kits causes problems. This upgrade might be needed sooner than eighteen months.

**Pre-built machines.** I found four comparable options from Sulpak and Shop.kz, using prices recorded on 2026-11-23. Since the listed towers do not include an operating system, I added the relevant OS cost and the same monitor allowance as in my custom builds. The pre-built machines are not identical to mine, but the comparison shows what the company would actually receive.

| Role | Pre-built model | Main parameters | Pre-built with monitor and OS, KZT | My build, KZT |
| --- | --- | --- | ---: | ---: |
| Accountant | ARG Office T01 (Sulpak) | Core i5-12400, 16 GB RAM, 1 TB SSD | 547,989 | 578,150 |
| Sales manager | ARG Office T01 (Sulpak) | Core i5-12400, 16 GB RAM, 1 TB SSD | 547,989 | 563,150 |
| Web developer | WW-KZ (Shop.kz) | Core i5-14400, RTX 3050 6 GB, 32 GB DDR5, 1 TB SSD | 779,390 | 651,202 |
| Designer | WW-KZ (Shop.kz) | Ryzen 5 7500F, RTX 5060 Ti 8 GB, 32 GB DDR5, 1 TB SSD | 1,187,589 | 1,182,207 |
| **Total** | | | **3,062,957** | **2,974,709** |

The office pre-built PCs are actually cheaper than my office builds, while the developer's pre-built costs more partly because it includes a GPU that is not necessary for the assumed workload. The designer's pre-built costs almost the same, but has a different CPU and GPU. Overall, the four pre-built workstations cost **88,248 KZT more**. Buying pre-built would save assembly and troubleshooting time and provide one warranty contact for each tower. Building the PCs gives more control over the motherboard, power supply, cooling and upgrade options. All four alternatives, links, dates and pricing assumptions are in [prebuilt-comparison.md](evidence/prebuilt-comparison.md).

**Who will complain within a month, and about what?** Probably the sales manager, about memory. CRM, Excel, a video call and 30-40 browser tabs at once can make 16 GB feel tight. If Windows starts paging to the SATA SSD, switching between applications may become slow during a call. This is the trade-off I accepted to keep the total below the budget, with a RAM upgrade planned if the problem appears.

I used ChatGPT Work to open vendor product pages and capture most of the price screenshots in `evidence/vendor-quotes/`. I reviewed the screenshots and checked the prices and product details against `budget.csv`.

## 4. Evidence

- [evidence/vendor-quotes/](evidence/vendor-quotes/) - screenshots of component models, prices, vendor pages and dates, named by role and part (for example `sales-memory.png`), including the four pre-built quotations.
- [evidence/pcpartpicker-links.md](evidence/pcpartpicker-links.md) - four saved PCPartPicker lists with compatibility notes and explanations of equivalent components used when exact models were unavailable.

## 5. What I would do differently

I would ask the director about the required software, existing licences and peripherals before choosing any parts. I would also measure how much RAM the sales team uses with its actual CRM and video calls instead of relying on an estimate, since 16 GB is the biggest performance compromise. Finally, I would request a written quote for the full quantities and leave a larger reserve for delivery and price changes, especially when the monitors have limited stock.
