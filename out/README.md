# TxBooster_INT v0.0.3

## Deskripsi
TxBooster_INT adalah modul Magisk yang dirancang untuk meningkatkan stabilitas koneksi jaringan di perangkat Android dengan melakukan optimasi adaptif pada txqueuelen dan MTU. Modul ini mendukung profiling dan logging sebelum dan sesudah tweak, notifikasi status, serta dashboard berbasis web (KsuWebUI) untuk monitoring dan pengaturan parameter secara real-time.

## Fitur Utama
- **Adaptive Network Tuning**: Optimasi otomatis txqueuelen dan MTU sesuai kondisi jaringan, berjalan sebagai service saat boot.
- **Profiling & Logging**: Melakukan profiling sebelum dan sesudah tweak, dengan penyimpanan log di storage perangkat, termasuk rotasi log otomatis untuk menghapus log lebih dari 3 hari.
- **Notification System**: Memberikan notifikasi sukses atau gagal tweak.
- **KsuWebUI**: Dashboard web sederhana untuk monitoring status tweak, melihat log, mengaktifkan/nonaktifkan tweak, dan mengubah parameter tweak.
- **Modular Magisk Integration**: Modul yang mudah diinstall dan diuninstall tanpa mengganggu sistem utama.
- **Fallback & Error Handling**: Pemeriksaan interface jaringan, timeout, dan fallback otomatis jika terjadi kegagalan.
- **Log Activity Management**: Mengelola log secara otomatis, menghapus log yang lebih tua dari 3 hari.
- **Integrasi dengan Shizuku**: (Rencana) Memudahkan akses dan automasi tanpa perlu root penuh.

## Roadmap Phase 1
- Adaptive Network Tuning (txqueuelen + MTU otomatis, boot service)
- Profiling & Logging (before & after tweak, simpan log ke storage, dengan rotasi log 3 hari)
- Notification System (notifikasi sukses/gagal tweak)
- KsuWebUI basic (dashboard status, lihat log, tombol aktif/nonaktif tweak, setting parameter tweak)
- Modular Magisk Integration (modul terpisah, mudah install/uninstall)
- Fallback & Error Handling (cek interface, timeout, fallback)
- Log activity management (auto delete log older than 3 days)
- Alat bantu Shizuku (future integration)

## Tujuan dan Kegunaan
Modul ini dibuat untuk memastikan koneksi jaringan tetap stabil di segala kondisi, terutama saat bermain game atau aplikasi yang membutuhkan latency rendah. Modul juga mampu belajar secara mandiri untuk menyesuaikan konfigurasi dan menyelesaikan masalah dengan cepat.

## Struktur Proyek
- `/module`: File dan skrip modul Magisk utama
- `/ksuwebui`: Dashboard web untuk monitoring dan konfigurasi
- `/logs`: Tempat penyimpanan log profiling
- `/scripts`: Skrip bash untuk tweak dan profiling
- `README.md`: Dokumentasi proyek
- `LICENSE`: Lisensi proyek

## Cara Instalasi
1. Pasang Magisk di perangkat Android kamu.
2. Instal modul TxBooster via Magisk Manager.
3. Pastikan perangkat sudah reboot untuk menjalankan service tweak.
4. Akses dashboard KsuWebUI dari browser untuk monitoring.

## Kontribusi
Kontribusi sangat diterima! Silakan buka issue atau pull request untuk saran, bug, atau fitur baru.

## Lisensi
Proyek ini dirilis di bawah lisensi MIT.

---

**Catatan:** Dokumentasi ini akan terus diperbarui seiring perkembangan proyek.

