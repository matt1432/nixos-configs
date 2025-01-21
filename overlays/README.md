# Overlays

This directory contains every overlay exposed by this flake.

## List of my overlays found in `self.overlays`

| Name | Description |
| ---- | ----------- |
| `misc-fixes` | Fixes build failures, missing meta attributes, evaluation failures, etc. of the current `nixpkgs` revision of this flake. |
| `nix-version` | Overrides the nix package for everything so I don't need multiple versions. |
| `xdg-desktop-portal-kde` | Fixes this issue: https://invent.kde.org/plasma/xdg-desktop-portal-kde/-/issues/15 |
