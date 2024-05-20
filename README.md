# My NixOS configs

## Ags

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
running NixOS or Nix. I tend to mix Home-Manager and NixOS
a lot to make my custom modules by using my global vars system
explained
[here](https://git.nelim.org/matt1432/nixos-configs/src/branch/master/devices)

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
| `formatter`                        | I have yet to know if this has any uses but I format with [alejandra](https://github.com/kamadorueda/alejandra) |
| `devShells.default`                | A dev shell to build an ISO from the live-image nixosConfiguration |

### Flake Inputs

To allow use of the nix language for my inputs, I use [genflake](https://github.com/jorsn/flakegen).
Therefore, the flake I edit is located at `./flake.in.nix`.

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
  oksys = "somekey2";
in {
  creation_rules = [
    {
      path_regex = "secrets/[^/]+\\.(yaml|json|env|ini)$";
      key_groups = [
        {
          age = [wim oksys];
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
