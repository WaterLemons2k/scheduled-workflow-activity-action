#!/bin/sh

_esc() {
    printf '\e[%sm' "$1"
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
