#!/bin/sh

CPU_USAGE=$(ps -A -o %cpu | awk '{s+=$1} END {printf "%.0f", s}')

sketchybar --set cpu label="${CPU_USAGE}%"
