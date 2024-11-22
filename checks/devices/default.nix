# CI: https://github.com/Mic92/dotfiles/blob/c2f538934d67417941f83d8bb65b8263c43d32ca/flake.nix#L168
{
  pkgs,
  self,
}: let
  inherit (pkgs.lib) filterAttrs mapAttrs' nameValuePair;
in
  mapAttrs'
  (name: config: nameValuePair "nixos-${name}" config.config.system.build.toplevel)
  ((filterAttrs (_: config: config.pkgs.system == pkgs.system)) self.nixosConfigurations)
