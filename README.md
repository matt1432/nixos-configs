# My NixOS configs

TODO: add directory structure info and enforce it
    - every root folder in the repo represents a flake output except inputs
    - every root folder only has a `default.nix` and subfolders for each
      of its attrs
    - in a subfolder, there should always be a `default.nix`
    - if there is non nix code, it will be in a `config` folder
    - redo docs
    - every module should not do anything if imported
    - all nix files that represent a module should be `default.nix` (a nix file
      which is imported directly can be called anything alongside `default.nix`)

## AGS

You might find it weird that most of my config is written in TypeScript.
That's because all my desktops run
[AGS](https://github.com/Aylur/ags)
for UI. Click on
[this](https://git.nelim.org/matt1432/nixos-configs/src/branch/master/modules/ags)
to see my configuration.

I'm also a victim of Stockholm syndrome at this point and make my scripts
in TypeScript because it's the scripting language I am most comfortable with.

## About

### General

This repo is the complete configuration of machines I own,
running NixOS or Nix. Its structure is based on a flake's
[outputs](https://wiki.nixos.org/wiki/Flakes#Output_schema).

### Flake Location

This git repo will always be located at `$FLAKE` (`config.environment.variables.FLAKE`)
and symlinked to `/etc/nixos` to have everything where NixOS tools
expect things to be.

ie.

```bash
sudo rm -r /etc/nixos

echo "$FLAKE" # /home/matt/.nix

sudo ln -sf /home/matt/.nix /etc/nixos
```

### Flake Outputs

| Output                             | Description |
| ---------------------------------- | ----------- |
| `nixosConfigurations`              | [devices](https://git.nelim.org/matt1432/nixos-configs/src/branch/master/devices)' + ISO's configurations |
| `nixOnDroidConfigurations.default` | [Nix-On-Droid](https://git.nelim.org/matt1432/nixos-configs/src/branch/master/devices/android)'s configuration |
| `packages`                         | Some custom [packages](https://git.nelim.org/matt1432/nixos-configs/src/branch/master/packages) not available in nixpkgs or modified from it |
| `scopedPackages`                   | Some custom [package scopes](https://git.nelim.org/matt1432/nixos-configs/src/branch/master/scopedPackages) not available in nixpkgs or modified from it |
| `apps`                             | Scripts ran from the flake defined [here](https://git.nelim.org/matt1432/nixos-configs/src/branch/master/apps) |
| `homeManagerModules`               | [Modules](https://git.nelim.org/matt1432/nixos-configs/src/branch/master/homeManagerModules) made for home-manager |
| `homeManagerModules`               | [Modules](https://git.nelim.org/matt1432/nixos-configs/src/branch/master/modules) made for NixOS systems |
| `formatter`                        | I format nix code with [alejandra](https://github.com/kamadorueda/alejandra) |
| `devShells.default`                | A dev shell to build an ISO from the live-image nixosConfiguration |
| `devShells.ags`                    | A dev shell to have a NodeJS env when I enter my AGS's config directory |

### Flake Inputs

To allow use of the full nix language for my inputs, I use [genflake](https://github.com/jorsn/flakegen).
Therefore, the flake I edit is located at `./outputs.nix`.

I also prefer using a more descriptive format for my inputs like so:

```nix
nixpkgs = {
  type = "github";
  owner = "NixOS";
  repo = "nixpkgs";

  # Branch name
  ref = "nixos-unstable";

  # Pin this input to a specific commit
  rev = "842d9d80cfd4560648c785f8a4e6f3b096790e19";
};
```

to make it more clear what is what in the flake URI

### Secrets

All my secrets are in a private git repo that makes use of
[sops-nix](https://github.com/Mic92/sops-nix).
I generate `.sops.yaml` from `.sops.nix`:

```nix
let
  wim = "somekey";
  binto = "somekey2";
in {
  creation_rules = [
    {
      path_regex = "secrets/[^/]+\\.(yaml|json|env|ini)$";
      key_groups = [
        {
          age = [wim binto];
        }
      ];
    }
  ];
}
```

which is then converted to `.sops.yaml` using
[remarshal](https://github.com/remarshal-project/remarshal)
and this shell command:

```bash
nix eval --json --file ./.sops.nix | remarshal --if json --of yaml > .sops.yaml
```

TLDR: I
**[hate](https://ruudvanasseldonk.com/2023/01/11/the-yaml-document-from-hell)**
YAML
