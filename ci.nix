# CI: https://github.com/Mic92/dotfiles/blob/c2f538934d67417941f83d8bb65b8263c43d32ca/flake.nix#L168
{
  system,
  pkgs,
  self,
}: let
  inherit (pkgs.lib) filterAttrs mapAttrs' nameValuePair;

  nixosMachines =
    mapAttrs'
    (name: config: nameValuePair "nixos-${name}" config.config.system.build.toplevel)
    ((filterAttrs (_: config: config.pkgs.system == system)) self.nixosConfigurations);

  devShells =
    mapAttrs'
    (n: nameValuePair "devShell-${n}")
    self.devShells;
in
  nixosMachines // devShells
