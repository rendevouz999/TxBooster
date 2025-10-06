#!/system/bin/sh
# post-fs-data.sh untuk TxBooster
# Menjalankan service.sh saat boot selesai file system mount

/data/adb/modules/txbooster/service.sh &
