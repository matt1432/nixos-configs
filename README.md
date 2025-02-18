# My NixOS configs

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

This repo is the complete configuration of machines I own running NixOS or Nix
and any other related smaller projects exposed by a Nix Flake.

Its main directory structure is based on a flake's
[outputs](https://wiki.nixos.org/wiki/Flakes#Output_schema).

I try to follow a few rules to better organise my Nix code:

  - Every main subdirectory only has an optional `default.nix` and subfolders for each
    of its attributes.
  - Inside a subdirectory, if there is non nix code, it will be in a `config` folder.
  - Every module should not do anything if imported. An enable option should be toggled
    for it to have any effect.
  - Any nix file that represents a module should be named `default.nix` (a nix file
    which is imported directly can be called anything else alongside `default.nix`)

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

### Subdirectories

| Output / Directory   | Description |
| -------------------- | ----------- |
| `apps`               | [Misc scripts ran from the flake](./apps)                                                   |
| `configurations`     | [device, ISO and nix-on-droid configurations](./configurations)                             |
| `devShells`          | [Development shells for a bunch of projects and languages](./devShells)                     |
| `homeManagerModules` | [Modules made for home-manager](./homeManagerModules)                                       |
| `inputs`             | [Pre-evaluated flake inputs](./inputs)                                                      |
| `lib`                | [Custom Nix functions made easily available](./lib)                                         |
| `modules`            | [Modules made for NixOS systems](./modules)                                                 |
| `nixFastChecks`      | [Attribute set of derivations exposed by this flake](./nixFastChecks)                       |
| `overlays`           | [Nixpkgs overlays](./overlays)                                                              |
| `packages`           | [Some custom packages not available in nixpkgs or modified from it](./packages)             |
| `results`            | Directory where I neatly keep my result symlinks from `nixFastChecks`                       |
| `scopedPackages`     | [Some custom package scopes not available in nixpkgs or modified from it](./scopedPackages) |

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

TLDR: I **[hate](https://ruudvanasseldonk.com/2023/01/11/the-yaml-document-from-hell)** YAML
