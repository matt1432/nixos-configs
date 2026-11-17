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

  systemd.services.jellyfin.serviceConfig.TimeoutStopSec = "1min";

  services.jellyfin = {
    enable = true;

    waitForReady.enable = true;

    # NOTE: nvidiaPackages.latest (615.78) only supports up to CUDA 13.4.
    ffmpegPackage = pkgs.jellyfin-ffmpeg-cuda.override {
      cudaPackages = pkgs.cudaPackages_13_4;
    };

    webPackage = pkgs.jellyfin-web.override {
      forceEnableBackdrops = true;
      forceDisablePreferFmp4 = true;
    };
  };
}
