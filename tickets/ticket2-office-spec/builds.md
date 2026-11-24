# Ticket 2 — Computer builds

Prices and vendors are in [budget.csv](budget.csv). See the [compatibility checks](evidence/pcpartpicker-links.md) for the hardware interfaces and open checks.

## Build — Accountant

**Load** — During a typical eight-hour day, I expect 1C, Excel, PDFs and email to stay open together, with larger exports at month-end.

**Bottleneck** — Opening exports and working with several spreadsheets can put pressure on storage and memory. A hard drive would make file opening and paging slower.

**Trade-off** — I kept 16 GB, a 1 TB SATA SSD and integrated graphics. I gave up NVMe speeds and a separate GPU because this workload is mostly documents and spreadsheets.

**Total** — 578,150 KZT

## Build — Sales manager

**Load** — I assume CRM, Excel and 30–40 browser tabs, with up to four hours of video calls on busy days.

**Bottleneck** — RAM is likely to fill first when a call, CRM and spreadsheets overlap. Paging can make window switching slow and interrupt calls.

**Trade-off** — I kept 16 GB instead of 32 GB and put the savings toward the developer and designer builds. The board has spare DIMM slots, and the graphics are integrated.

**Total** — 563,150 KZT

## Build — Web developer

**Load** — I assume a full workday with an IDE, multiple browsers, a local database and three to five Docker containers, with occasional VM use.

**Bottleneck** — Memory fills when databases, containers and browsers run together. An NVMe SSD helps with images, dependencies and builds.

**Trade-off** — I used 32 GB, AM5 and NVMe. I chose integrated graphics and an FHD screen so the budget goes to memory and storage. Ubuntu fits the assumed Linux-based tools.

**Total** — 651,202 KZT

## Build — Designer

**Load** — I assume several hours a day in Photoshop, Illustrator and Figma, with large multi-layer files and occasional Blender previews.

**Bottleneck** — GPU and VRAM limit larger Blender scenes. Open layered files use system RAM, and a QHD screen gives more space for the canvas and tools.

**Trade-off** — I kept 32 GB RAM, an 8 GB RTX 5060 and a 27-inch QHD IPS monitor. I gave up 64 GB and a higher-VRAM GPU to stay within the shared budget.

**Total** — 1,182,207 KZT
