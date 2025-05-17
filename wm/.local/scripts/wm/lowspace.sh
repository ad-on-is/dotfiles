#!/bin/bash

df -P | awk '0+$5 >= 90 {print}' | awk '{print $5" "$6}' | tr '\n' ', '
