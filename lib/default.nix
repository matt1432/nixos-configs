{
  perSystem,
  inputs,
}: let
  flake = import ./flake inputs;
  strings = import ./strings inputs.nixpkgs.lib;

  lib = flake // strings;
in
  # Expose main attrs
  lib
  # Expose all funcs
  // strings
  // flake
  # Expose funcs that require pkgs
  // perSystem (
    pkgs:
      (import ./pkgs {
        inherit pkgs;
        inherit (inputs) self;
      })
      // lib
  )
