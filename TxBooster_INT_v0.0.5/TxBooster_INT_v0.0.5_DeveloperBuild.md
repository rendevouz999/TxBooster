
# 🧩 TxBooster_INT v0.0.5 – Developer Build (Hybrid AI Policy)
**Author:** Jxey  
**GitHub:** [https://github.com/rendevouz999/TxBooster](https://github.com/rendevouz999/TxBooster)  
**Email:** txbooster.int@gmail.com  
**Mode:** Root & Non-root Hybrid  
**Date:** 2025-10-07  
**Status:** Developer-Ready (Field Implementation)  
**Compatibility:** Android 8+  

---

## 🔧 Struktur Folder Lengkap
```
TxBooster_INT_v0.0.5/
├── META-INF/com/google/android/
│   ├── update-binary
│   └── updater-script
├── module.prop
├── change.log
├── config/
│   ├── baseline.conf
│   ├── mode.conf
├── core/
│   ├── txbooster_core.sh
│   ├── profiling.sh
│   ├── auto_selector.sh
│   ├── helper.sh
│   ├── log_manager.sh          <-- (AI Policy)
│   ├── anti_bootloop_guard.sh
│   ├── auto_update.sh
│   ├── ai_sync.sh
│   └── system_tweaker.sh
├── data/
│   └── self_heal.db
└── logs/
    └── manager.log
```

---

## ⚙️ module.prop
```properties
id=txbooster_int
name=TxBooster_INT
version=0.0.5
versionCode=5
author=Jxey
description=TxBooster_INT Hybrid AI v0.0.5 | Self-Healing + AI Policy System | Root/Non-Root Sync
```

---

## 🧾 change.log
```
# v0.0.5 (Developer Edition)
- AI Policy Cleanup System (log relevance scoring)
- Integrated self_heal.db for adaptive housekeeping
- Cross-device synchronization (root ↔ non-root)
- Smart log retention (keeps only relevant logs)
- Auto-update sync and rollback-safe operation
- Reintroduced log rotation 3 days + AI scoring
```

---

## 🧠 core/log_manager.sh (AI Policy Mode)
*(See full script in implementation folder)*

---

## 🔁 core/txbooster_core.sh
*(Core engine sequence: profiling → apply tweaks → AI policy cleanup → update check)*

---

## 🧬 data/self_heal.db
Auto-generated SQLite database containing:
- `log_relevance` table with fields:
  - `log_name`, `last_used`, `relevance_score`, `size_kb`, `last_action`.

---

## 🧩 Non-Root (Shelter Side)
Runs in Termux with `self_heal_policy.py` and Flask-based `shelter_server.py`.

---

## 🌍 Sinkronisasi AI antar perangkat
Rooted and Non-rooted devices share relevance scores through JSON API over Shelter Server.

---

## 🔮 Evolusi Setelah Implementasi
| Versi | Fokus | Target |
|--------|--------|--------|
| v0.0.5 | AI Policy + DB scoring | Field test di 2 perangkat |
| v0.0.6 | Cross-sync AI cloud | Federated learning aktif |
| v0.0.7 | Dashboard UI | Shelter Web Dashboard |
| v0.1.0 | Full autonomous engine | Self-heal & self-update otomatis |

---

## ✅ Ringkasan Fitur Utama (v0.0.5)
| Komponen | Status | Fungsi |
|-----------|---------|--------|
| Hybrid Core (root/non-root) | ✅ Aktif | Sistem adaptif lintas mode |
| AI Policy Log Cleanup | ✅ Baru | Log management cerdas berbasis relevansi |
| Self-heal Database | ✅ Baru | Menyimpan skor relevansi log |
| Shelter Integration | ✅ Siap | Sinkronisasi antar perangkat |
| Auto-update | ✅ Aktif | Update GitHub / lokal |
| Anti-bootloop | ✅ Aktif | Revert tweak gagal |
| Profiling & History | ✅ Stabil | Pembelajaran lokal |

---

### 🔐 Secure Signature
```
[BEGIN-TXB-HYBRID-SIGNATURE]
QXV0aG9yOiBKeGV5IHwgVHJ1c3RlZCBTaWduYXR1cmUgQmFzZWQgb24gUHJpdmF0ZSBTZWVkICgzZjlhMWU2YikK[ENCRYPTED]
[END-TXB-HYBRID-SIGNATURE]
```
