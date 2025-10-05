# TxBooster_INT_v0.0.3

## Deskripsi Proyek
TxBooster_INT adalah modul Magisk yang bertujuan untuk mengoptimalkan parameter jaringan di perangkat Android secara adaptif. Fokus utama pada pengaturan `txqueuelen` dan `MTU` untuk meningkatkan stabilitas koneksi terutama dalam penggunaan berat seperti gaming dan streaming.

Modul ini menyediakan profil jaringan sebelum dan sesudah tweak dengan pencatatan log yang terorganisir dan sistem notifikasi untuk memantau status tweak. Selain itu, dilengkapi dengan WebUI sederhana bernama **KsuWebUI** yang memungkinkan pengguna memantau status, mengaktifkan/mematikan tweak, serta mengubah parameter secara real-time.

## Fitur Utama

- **Adaptive Network Tuning**
  - Otomatis mengatur nilai `txqueuelen` dan `MTU` berdasarkan kondisi interface jaringan aktif (WiFi, data seluler).
  - Mengoptimalkan koneksi untuk stabilitas maksimum, terutama saat bermain game.

- **Profiling & Logging**
  - Mencatat statistik jaringan sebelum dan sesudah tweak.
  - Log disimpan ke penyimpanan perangkat dengan rotasi otomatis selama 3 hari, untuk mencegah penumpukan data.

- **Notification System**
  - Memberikan notifikasi ketika tweak berhasil dijalankan atau jika terjadi kegagalan.

- **KsuWebUI Basic**
  - Dashboard status real-time.
  - Melihat log aktivitas.
  - Tombol aktif/nonaktif tweak.
  - Pengaturan parameter tweak secara langsung.

- **Modular Magisk Integration**
  - Disusun sebagai modul terpisah yang mudah dipasang dan dicopot.
  - Memanfaatkan service.d untuk menjalankan skrip secara otomatis saat boot.

- **Fallback & Error Handling**
  - Memeriksa interface jaringan secara dinamis.
  - Timeout dan fallback otomatis untuk menghindari kegagalan tweak.

- **Log Activity Management**
  - Menghapus log lama secara otomatis yang berumur lebih dari 3 hari.

- **Dukungan Alat Bantu Shizuku**
  - Mempermudah akses dan kontrol sistem tanpa perlu root secara penuh.

## Roadmap Phase 1

1. Adaptive Network Tuning (txqueuelen + MTU otomatis, boot service)
2. Profiling & Logging (before & after tweak, simpan log ke storage, dengan rotasi log 3 hari)
3. Notification System (notifikasi sukses/gagal tweak)
4. KsuWebUI Basic (dashboard status, lihat log, tombol aktif/nonaktif tweak, setting parameter tweak)
5. Modular Magisk Integration (modul terpisah, mudah install/uninstall)
6. Fallback & Error Handling (cek interface, timeout, fallback)
7. Log activity management (auto delete log older than 3 days)
8. Integrasi alat bantu Shizuku untuk akses kontrol lebih mandiri dan aman.

## Proyek Sebelumnya
Proyek ini merupakan kelanjutan dari **TxBooster_v0.0.1** yang mengutamakan kestabilan koneksi jaringan dalam semua kondisi, terutama saat bermain game. Fokusnya adalah modul yang bisa belajar secara otomatis (self-learning) untuk menyelesaikan masalah jaringan dengan cepat dan efisien.

---

## Cara Kontribusi
Silakan fork repo ini dan buat pull request untuk kontribusi fitur baru atau perbaikan.

## Lisensi
MIT License

---

*Terima kasih telah berkontribusi dan menggunakan TxBooster_INT!*

