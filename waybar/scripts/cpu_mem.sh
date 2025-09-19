#!/usr/bin/env bash
MODE="$1"

get_cpu() {
  read -r cpu a b c d e f g h i j < /proc/stat
  prev_idle=$((d + e))
  prev_total=$((a+b+c+d+e+f+g+h+i+j))
  sleep 0.35
  read -r cpu a b c d e f g h i j < /proc/stat
  idle=$((d + e))
  total=$((a+b+c+d+e+f+g+h+i+j))
  dif_idle=$((idle - prev_idle))
  dif_total=$((total - prev_total))
  usage=$((100 * (dif_total - dif_idle) / dif_total))
  echo "$usage"
}

get_ram() {
  mem_total=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
  mem_free=$(awk '/MemAvailable/ {print $2}' /proc/meminfo)
  used=$((mem_total - mem_free))
  pct=$((100 * used / mem_total))
  used_mb=$((used / 1024))
  total_mb=$((mem_total / 1024))
  echo "$pct $used_mb $total_mb"
}

case "$MODE" in
  cpu)
    usage=$(get_cpu)
    printf '{"text":"%s%%","class":"cpu","percentage":%s,"style":"--pct:%s; background: conic-gradient(#ffb86b calc(var(--pct)*1%%), rgba(255,255,255,0.06) 0);"}' "$usage" "$usage" "$usage"
    ;;
  ram)
    read -r pct used total <<< "$(get_ram)"
    printf '{"text":"%sMB","class":"ram","percentage":%s,"tooltip":"%s/%s MB","style":"--pct:%s; background: conic-gradient(#7bd389 calc(var(--pct)*1%%), rgba(255,255,255,0.06) 0);"}' "$used" "$pct" "$used" "$total" "$pct"
    ;;
  *)
    echo '{"text":"-","class":"info"}'
    ;;
esac
