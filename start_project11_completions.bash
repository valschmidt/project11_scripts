#!/usr/bin/bash
# 
# Completions file for start_project11

LAUNCHDIR=`rospack find project11`/launch
LAUNCHFILES=`ls "${LAUNCHDIR}"`
complete -o filenames -W "${LAUNCHFILES[@]}" start_project11
