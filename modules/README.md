# NixosModules

This directory contains every modules for NixOS exposed by this flake.

## List of my modules found in `self.nixosModules`

| Name | Description |
| ---- | ----------- |
| `base` | Sets up locale, nix config, binary caches, general packages and some miscellaneous configs I might want on every device I use. |
| `base-droid` | Sets up locale, nix config, binary caches, general packages and some miscellaneous configs I might want on every nix-on-droid device I use. |
| `borgbackup` | Sets up a wrapper around `services.borgbackup` to setup default behaviour and make configuration of backups easier. |
| `caddy-plus` | Extends the caddy options to allow declaring subdirectory routes and reverse proxy directives through nix code. |
| `desktop` | Sets up a Display Manager, a Desktop Environment and themes for any graphical apps to use the Dracula Theme. This module uses Hyprland as window manager and AGS / Astal for the UI. |
| `docker` | Imports [nixos-docker-compose](https://github.com/matt1432/nixos-docker-compose), sets default options such as BTRFS filesystem and adds an update script for images. |
| `esphome-plus` | Fixes a bug with compilation of m5-atom-stack firmware and allows declaring firmware configurations in nix code. |
| `ha-plus` | Extends the home-assistant options to allow declaring the content of specific configuration files in the home-assistant configuration directory such as custom sentences through nix code. |
| `jmusicbot` | Allows declaring multiple JMusicBot instances. |
| `kmscon` | Extends the kmscon options to add more descriptive ones. |
| `meta` | Adds options to declare the documentation of my devices that will be generated to `./configurations/README.md`. |
| `nvidia` | Abstracts NVIDIA options and miscellaneous fixes behind simpler options. |
| `plymouth` | Sets some boot options to make the boot sequence cleaner. |
| `server` | Sets up sshd, tailscale and related configurations. |
| `tmux` | Uses the home-manager tmux module to declare my custom configuration and links it to `/etc` to set it globally. |
| `wyoming-plus` | Extends the `wyoming.openwakeword` options to allow declaring flags used by the [fork](https://github.com/rhasspy/wyoming-openwakeword/pull/17) of `wyoming-openwakeword` exposed by this module. |
