# Devices

This directory encompasses every device's main configuration file.

## List of my Devices

| Name       | Description                                                                                             |
| ---------- | ------------------------------------------------------------------------------------------------------- |
| `android`  | My [Nix-On-Droid](https://github.com/nix-community/nix-on-droid) configuration for my OnePlus 9 Pro |
| `binto`    | My desktop PC with a multi-monitor setup and an NVIDIA (cringe) 3070 |
| `cluster`  | Two Lenovo mini pcs that make use of [NixOS-pcsd](https://github.com/matt1432/nixos-pcsd) to form a cluster |
| `nas`      | My current custom built server running Proxmox. Conversion to NixOS wip |
| `oksys`    | A very old Acer laptop that went from sailing the seas for years to becoming my web server and VPN host. It is now retired indefinitely. |
| `servivi`  | A gaming PC in a previous life, it is now used to slowly convert my Proxmox server to NixOS |
| `wim`      | My 2-1 Lenovo Laptop that I use for uni |

## Global Vars

In every device's `default.nix`, you'll find these [settings](https://git.nelim.org/matt1432/nixos-configs/src/branch/master/common/vars.nix)

```nix
# $FLAKE/devices/<name>/default.nix

vars = {
  mainUser = "matt";
  hostName = "wim";
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
