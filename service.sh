#!/system/bin/sh
# TxBooster service v0.0.2
# Menjalankan optimasi MTU dan txqueuelen

LOGFILE="/data/adb/modules/txbooster/txbooster.log"
echo "[TxBooster] Service started at $(date)" > "$LOGFILE"

# Pilih interface: prioritas wlan0, fallback rmnet_data0
IFACE="wlan0"
if ! ip link show "$IFACE" > /dev/null 2>&1; then
  IFACE="rmnet_data0"
fi

echo "[TxBooster] Using interface: $IFACE" >> "$LOGFILE"

# Notifikasi pengaktifan
if command -v cmd >/dev/null 2>&1; then
  cmd notification post TxBooster "TxBooster activated on $IFACE"
fi

# Daftar nilai txqueuelen untuk dicoba
VALUES="100000 50000 20000 10000 4000"

APPLIED=0
for v in $VALUES; do
  if ifconfig "$IFACE" txqueuelen "$v" 2>/dev/null; then
    echo "[OK] Applied txqueuelen=$v on $IFACE" >> "$LOGFILE"
    APPLIED=1
    break
  else
    echo "[Fail] Could not apply txqueuelen=$v on $IFACE" >> "$LOGFILE"
  fi
done

if [ "$APPLIED" -eq 0 ]; then
  echo "[ERROR] Failed to apply any txqueuelen value on $IFACE" >> "$LOGFILE"
fi

# Optimasi MTU jika >1400
CURRENT_MTU=$(ip link show "$IFACE" | grep mtu | awk '{for(i=1;i<=NF;i++) if($i=="mtu") print $(i+1)}')
if [ -n "$CURRENT_MTU" ] && [ "$CURRENT_MTU" -gt 1400 ]; then
  ip link set dev "$IFACE" mtu 1400
  echo "[MTU] Changed MTU from $CURRENT_MTU to 1400 on $IFACE" >> "$LOGFILE"
else
  echo "[MTU] MTU is $CURRENT_MTU on $IFACE, no change needed" >> "$LOGFILE"
fi

# Notifikasi selesai optimasi
if command -v cmd >/dev/null 2>&1; then
  cmd notification post TxBooster "MTU & txqueuelen optimized on $IFACE"
fi

exit 0
