# README_DEV — TxBooster_INT Developer Notes (v0.0.5)

**Author:** Jxey  
**Contact:** joefreccejunior50@gmail.com  
**Branch target:** main (TxBooster_INT_v0.0.5)  
**Signature seed:** #3f9a1e6b

## Purpose
This document is for maintainers and contributors. It explains the hybrid architecture, how to build, test and extend the self-learning and server-sync components.

## Developer Quick Tasks
- Run `shellcheck` on `core/*.sh`
- Install shelter dependencies in Termux as needed
- Use `builder.sh` to produce Magisk ZIP and checksum
- To simulate sync: run `txcloud_sync.py` locally and run `core/ai_sync.sh` in an environment with sqlite DB

## Branching model
- `main` → production (now v0.0.5)
- `dev/*` → feature branches
- `legacy/*` → old versions

## Build
```bash
# from repo root
bash builder.sh
# output in ./out/TxBooster_INT_v0.0.5.zip
```

## Auto-update
`core/auto_update.sh` checks GitHub releases. `update.json` is included for Magisk-style clients.

## API (Shelter v0.0.6)
See `docs/SHELTER_v0.0.6_API.md` for endpoint specs and auth model.

[BEGIN-TXB-HYBRID-SIGNATURE]
QXV0aG9yOiBKeGV5IHwgU2lnbmVkIFdpdGggRW5jcnlwdGlvbiBTZWVkICgzZjlhMWU2YikK[ENCRYPTED]
[END-TXB-HYBRID-SIGNATURE]

