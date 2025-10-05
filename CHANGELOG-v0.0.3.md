========================
TxBooster_INT - Change Log
========================

## [v0.0.3] – 2025-10-05
### 🔧 Core Improvements
- Implementasi **self-learning engine** berbasis baseline `TxBooster_V0.0.1`
- Auto profiling jitter & delay sebelum dan sesudah tweak (`profiling.sh`)
- Optimasi pengaturan `txqueuelen` & `MTU` secara adaptif berdasarkan hasil pengujian
- Sistem pencatatan hasil tweak ke `history.csv` (berisi versi, timestamp, delay, dan hasil)

### 🧠 Smart Features
- Penentuan tweak terbaik otomatis berdasarkan data performa sebelumnya
- Deteksi performa “success” / “fallback” untuk pembelajaran berkelanjutan
- Integrasi awal ke **KsuWebUI** (struktur file siap, API dasar tersedia)

### 🧹 Log Management
- Penambahan `log_manager.sh` → auto-hapus log lebih dari 3 hari
- Struktur direktori log baru:
  - `logs/profile_YYYY-MM-DD_HH-MM-SS.log`
  - `logs/history.csv`

### ⚙️ System Integration
- `post-fs-data.sh` otomatis menjalankan service inti dan log manager
- Struktur folder lebih rapi, modular, dan siap untuk integrasi fitur berikutnya

### 🧩 Struktur Baru
