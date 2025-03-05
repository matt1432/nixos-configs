{
  config,
  jellyfin-flake,
  pkgs,
  ...
}: let
  jellyPkgs =
    if config.nvidia.enableCUDA
    # TODO: add overlays to upstream flake
    then jellyfin-flake.packages.${pkgs.system}.cudaPackages
    else jellyfin-flake.packages.${pkgs.system};
in {
  services.jellyfin = {
    package = jellyPkgs.jellyfin;
    webPackage = jellyPkgs.jellyfin-web.override {
      forceEnableBackdrops = true;
      forceDisablePreferFmp4 = true;
    };
    ffmpegPackage = jellyPkgs.jellyfin-ffmpeg;
  };
}
