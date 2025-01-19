#!/bin/sh
echo -ne '\033c\033]0;ugj #104\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/linux_export_1.x86_64" "$@"
