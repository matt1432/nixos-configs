# Devices

This directory encompasses every device's main configuration file.

## List of my Devices

| Name        | Description                                                                                             |
| ----------- | ------------------------------------------------------------------------------------------------------- |
| `android`   | My [Nix-On-Droid](https://github.com/nix-community/nix-on-droid) configuration for my OnePlus 9 Pro |
| `bbsteamie` | My wife's SteamDeck that has a pink case |
| `binto`     | My desktop PC with a multi-monitor setup and an NVIDIA (cringe) 3070 |
| `cluster`   | Two Lenovo mini PCs that make use of [NixOS-pcsd](https://github.com/matt1432/nixos-pcsd) to form a cluster |
| `homie`     | My Lenovo mini PC that will serve as a Home-assistant server |
| `nos`       | My custom built NAS |
| `servivi`   | A gaming PC in a previous life, it is now used as a build farm and hosts game servers |
| `wim`       | My 2-1 Lenovo Laptop that I use for uni |

## Global Vars

In every device's `default.nix`, you'll find these [settings](https://git.nelim.org/matt1432/nixos-configs/src/branch/master/common/vars/default.nix)

```nix
# $FLAKE/devices/<name>/default.nix

vars = {
  mainUser = "matt";
  ...
};
```

from these declared settings, I get access to global variables
that are different on each host using a 'let in' block:

```nix
let
  inherit (config.vars) mainUser ...;
in {
  ...
```
