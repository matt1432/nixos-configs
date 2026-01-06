{
  config,
  nixos-jellyfin,
  lib,
  mainUser,
  pkgs,
  ...
}: let
  inherit (lib) hasAttr optionals;

  optionalGroup = name:
    optionals
    (hasAttr name config.users.groups)
    [config.users.groups.${name}.name];
in {
  imports = [
    ./collections
    ./fix-cast
    ./jellarr.nix
    ./jfa-go.nix
    ./meilisearch.nix

    nixos-jellyfin.nixosModules.default
  ];

  # For GPU access. Not sure if needed anymore
  users.users."jellyfin".extraGroups =
    optionalGroup mainUser
    ++ optionalGroup "input"
    ++ optionalGroup "media"
    ++ optionalGroup "render"
    ++ optionalGroup "video";

  services.jellyfin = {
    enable = true;

    ffmpegPackage = pkgs.jellyfin-ffmpeg-cuda;

    webPackage = pkgs.jellyfin-web.override {
      forceEnableBackdrops = true;
      forceDisablePreferFmp4 = true;
    };
  };
}
