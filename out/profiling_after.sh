#!/system/bin/sh
# TxBooster Profiling Before v0.0.5
LOGDIR="/sdcard/txbooster_webui/logs"
LOGFILE="$LOGDIR/before.log"
IFACE="wlan0"

mkdir -p "$LOGDIR"

wait_for_iface() {
  local iface=$1
  local count=0
  while [ $count -lt 30 ]; do
    if ip link show "$iface" 2>/dev/null | grep -q "state UP"; then
      echo "[INFO] Interface $iface is UP" >> "$LOGFILE"
      return 0
    fi
    sleep 1
    count=$((count + 1))
  done
  echo "[WARN] Timeout waiting for interface $iface UP" >> "$LOGFILE"
  return 1
}

if ! ip link show "$IFACE" > /dev/null 2>&1; then
  IFACE="rmnet_data0"
fi

{
  echo "[TxBooster Profiling Before]"
  echo "Interface: $IFACE"
  echo "Timestamp: $(date '+%d/%m/%Y %H:%M:%S')"
} > "$LOGFILE"

wait_for_iface "$IFACE"
sleep 10

{
  echo "=== ip link show $IFACE ==="
  ip link show "$IFACE"
  echo ""
  echo "=== Network statistics /proc/net/dev for $IFACE ==="
  grep "$IFACE" /proc/net/dev
  echo ""
  echo "=== Ping test to 8.8.8.8 (10 packets) ==="
  ping -c 10 8.8.8.8
  echo ""
  echo "[Profiling selesai]"
} >> "$LOGFILE"

if command -v cmd >/dev/null 2>&1; then
  cmd notification post TxBooster "Profiling Before done, log saved."
fi

exit 0
