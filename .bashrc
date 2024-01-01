#!/bin/bash

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \[\e[0;33m\]\W\[\e[0m\]] \$ '
set -o vi

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Source my profile
. $HOME/.profile

# User specific aliases and functions
if [[ -d ~/.bashrc.d ]]; then
	for rc in ~/.bashrc.d/*; do
		if [[ -f "$rc" ]]; then
			. "$rc"
		fi
	done
fi

unset rc
