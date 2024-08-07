#!/usr/bin/env bash

CppProps() {
	cat >.vscode/c_cpp_properties.json <<EOF
{
    "configurations": [
        {
            "name": "Linux",
            "includePath": $includePaths,
            "defines": [],
            "compilerPath": "${clang}",
            "cStandard": "c23",
            "cppStandard": "c++23",
            "intelliSenseMode": "linux-clang-x64"
        }
    ],
    "version": 4
}
EOF
}

if [ ! -d /.vscode ]; then
  mkdir -p /.vscode
fi

includePaths=$(pkg-config --cflags gtk4 gtk4-layer-shell-0 gtkmm-4.0 | tr ' ' '\n' | grep '\-I' | sed 's/-I//g' | jq -R -s -c 'split("\n") | map(select(length > 0))')
clang=$(which clang)

CppProps
