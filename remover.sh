#!/usr/bin/env bash

#This script do only one thing: Remove everything (but not the base) of your system.
pacman -R $(comm -23 <(pacman -Qq | sort) <((for i in $(pacman -Qqg base); do pactree -ul "$i"; done) | sort -u))
