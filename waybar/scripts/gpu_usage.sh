#!/usr/bin/env bash

# Try NVIDIA first
if command -v nvidia-smi >/dev/null 2>&1; then
  read -r util mem_used mem_total <<< $(nvidia-smi --query-gpu=utilization.gpu,memory.used,memory.total --format=csv,noheader,nounits | head -n1 | tr -d '\r' | awk -F',' '{gsub(/ /,"",$1); gsub(/ /,"",$2); gsub(/ /,"",$3); print $1" "$2" "$3}')
  pct=${util:-0}
  mem_info="${mem_used}MB"
  printf '{"text":"%s%%","class":"gpu","percentage":%s,"tooltip":"GPU: %s MB","style":"--pct:%s; background: conic-gradient(#6ea8fe calc(var(--pct)*1%%), rgba(255,255,255,0.06) 0);"}' "$pct" "$pct" "$mem_info" "$pct"
  exit 0
fi

# Try AMD with radeontop
if command -v radeontop >/dev/null 2>&1; then
  pct=$(radeontop -l 1 -d - | grep -m1 'gpu ' | awk '{print $2}' | tr -d '%')
  pct=${pct:-0}
  printf '{"text":"%s%%","class":"gpu","percentage":%s,"tooltip":"AMD GPU","style":"--pct:%s; background: conic-gradient(#ff79c6 calc(var(--pct)*1%%), rgba(255,255,255,0.06) 0);"}' "$pct" "$pct" "$pct"
  exit 0
fi

# Fallback
printf '{"text":"N/A","class":"gpu","percentage":0,"style":"--pct:0; background: conic-gradient(rgba(255,255,255,0.06) 0, rgba(255,255,255,0.06) 0);"}'
