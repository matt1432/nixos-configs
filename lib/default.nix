{
  perSystem,
  inputs,
}: let
  attrs = import ./attrs {};
  flake = import ./flake inputs;
  hypr = import ./hypr inputs.nixpkgs.lib;
  strings = import ./strings inputs.nixpkgs.lib;

  lib = attrs // flake // hypr // strings;
in
  # Expose main attrs
  lib
  # Expose all funcs
  // {inherit attrs flake hypr strings;}
  # Expose funcs that require pkgs
  // perSystem (
    pkgs:
      (import ./pkgs {
        inherit pkgs;
        inherit (inputs) self;
      })
      // lib
  )
