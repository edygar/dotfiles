#!/usr/bin/env bash

DEV_HOME=$HOME/dev
session_name="$(echo "${1:${#DEV_HOME}}" | sed 's@/@ @g;s@^.@@g;s@ $@@g')"
echo -e "${session_name}\t$1"
