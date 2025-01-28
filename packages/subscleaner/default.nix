{
  pkgs,
  poetry2nix,
  subscleaner-src,
  ...
}: let
  inherit (poetry2nix.lib.mkPoetry2Nix {inherit pkgs;}) mkPoetryApplication;
in
  mkPoetryApplication {
    projectDir = subscleaner-src;
    preferWheels = true;
  }
