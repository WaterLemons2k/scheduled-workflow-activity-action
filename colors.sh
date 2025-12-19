#!/bin/sh

_esc() {
	if tty -s; then
		printf '\e[%sm' "$1"
	fi
}
_color() {
	printf '%s' "$(_esc "$1")$2$(_esc 0)"
}

red() {
	_color 31 "$1"
}
green() {
	_color 32 "$1"
}
