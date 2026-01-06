#!/bin/env bash

devices=$(cat /proc/acpi/wakeup | tail -n +2 | awk '{print $1}')
for device in $devices; do
  if [[ $device = "XHC0" ]]; then
    continue
  fi
  grep -q "$device.*\*enabled" /proc/acpi/wakeup && echo "$device >/proc/acpi/wakeup" || true

done
