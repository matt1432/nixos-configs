{
  inputs ? {},
  pkgs ? {},
  self ? {},
}: let
  lock = builtins.fromJSON (builtins.readFile ../flake.lock);

  lib = import "${builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/${lock.nodes.nixpkgs.locked.rev}.tar.gz";
    sha256 = lock.nodes.nixpkgs.locked.narHash;
  }}/lib";

  inherit (lib) concatStringsSep optionalAttrs stringToCharacters substring tail toUpper;

  mkVersion = src: "0.0.0+" + src.shortRev;
  capitalise = str: (toUpper (substring 0 1 str) + (concatStringsSep "" (tail (stringToCharacters str))));
in
  {inherit lib mkVersion capitalise;}
  // (import ./inputs.nix lib lock)
  // optionalAttrs (inputs != {}) (import ./flake-lib.nix inputs)
  // optionalAttrs (pkgs != {}) (import ./pkgs.nix pkgs mkVersion capitalise self)
