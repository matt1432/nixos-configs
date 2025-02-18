# Inputs

To allow use of the full nix language for my inputs, I use [genflake](https://github.com/jorsn/flakegen).
Therefore, the flake I edit is located at `$FLAKE/_outputs.nix`.

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
