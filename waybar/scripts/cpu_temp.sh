#!/usr/bin/env bash
export LC_ALL=C

temps=()

for zone in /sys/class/thermal/thermal_zone*/temp; do
    if [ -f "$zone" ]; then
        temp=$(cat "$zone")
        temp=$((temp / 1000))
        temps+=($temp)
    fi
done

# Calculate average temperature
if [ ${#temps[@]} -gt 0 ]; then
    sum=0
    for t in "${temps[@]}"; do
        sum=$((sum + t))
    done
    avg=$((sum / ${#temps[@]}))
else
    avg=0
fi


if [ $avg -lt 45 ]; then
    icon=""   
    class="low"
elif [ $avg -lt 70 ]; then
    icon=""   
    class="medium"
else
    icon=""   
    class="high"
fi


echo "$icon $avg°C"
echo "$icon $avg°C"
echo "$class"
