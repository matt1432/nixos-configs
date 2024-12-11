# CI: https://github.com/Mic92/dotfiles/blob/c2f538934d67417941f83d8bb65b8263c43d32ca/flake.nix#L168
{
  pkgs,
  self,
  onlyApt ? false,
}: let
  inherit (pkgs.lib) elem filterAttrs mapAttrs' nameValuePair;

  devices = filterAttrs (n: config: let
    isSameSystem = config.pkgs.system == pkgs.system;
  in
    if onlyApt
    then isSameSystem && elem n ["bbsteamie" "binto" "homie" "wim"]
    else isSameSystem)
  self.nixosConfigurations;
in
  mapAttrs'
  (name: config: nameValuePair "device_${name}" config.config.system.build.toplevel)
  devices
