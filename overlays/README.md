# Overlays

This directory contains every overlay exposed by this flake.

## List of my overlays found in `self.overlays`

| Name | Description |
| ---- | ----------- |
| `appsPackages` | This overlay puts every derivations for apps exposed by this flake under pkgs.appsPackages. |
| `forced` | Overrides packages from third party flakes that don't offer overlays. |
| `misc-fixes` | Fixes build failures, missing meta attributes, evaluation failures, etc. of the current `nixpkgs` revision of this flake. |
| `nix-version` | Overrides the nix package for everything so I don't need multiple versions. |
| `scopedPackages` | This overlay puts every package scopes exposed by this flake under pkgs.scopedPackages. |
| `selfPackages` | This overlay puts every derivations for packages exposed by this flake under pkgs.selfPackages. |
