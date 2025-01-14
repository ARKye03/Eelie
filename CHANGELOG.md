# Changelog

All notable changes to this project will be documented in this file.

## [0.0.1] - 2024-09-19

### 🚀 Features

- Add AppButton class for creating application buttons
- Add is_app_running function to check if the application is already running
- Update AppButton class to launch application with launch context
- :fire: Init git-cliff.toml, add CHANGELOG generation

### 🐛 Bug Fixes

- Loading the app before the css, refactored a piece of code

### 🚜 Refactor

- Consolidate event controllers for better code organization
- Refactor window.cpp and window.hpp for better code organization

### ⚙️ Miscellaneous Tasks

- Update GTK dependencies and configure layer shell margins
- Update .envrc with GTK and XCURSOR theme configurations
- Update .vscode settings for C++ file associations
- Update GTK layer shell margins and add CSS styling for master box
- Update default app configuration in flake.nix
- Update flake.nix to use version from file
- Remove commented out code and update flake.nix to use version from file
- Update flake.nix to allow use on non-nixos distros
- Remove redundant code for loading CSS in main.cpp and window.cpp
- Update AppButton launch method to include files and launch context
- Add git-cliff for autogenerated cahngelogs

<!-- generated by git-cliff -->
