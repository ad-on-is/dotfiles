#!/bin/env bash

cmd="flatpak run --command=cameractrls.py hu.irl.cameractrls"
settings=$(eval "$cmd -l")

if [[ "$1" == "zoom" ]]; then
  zoom=$(echo "$settings" | grep "zoom" | awk '{print $3}')
  if [[ "$zoom" == "100" ]]; then
    zoom="200"
  else
    zoom="100"
  fi
  eval "$cmd -c zoom_absolute=$zoom"
fi
