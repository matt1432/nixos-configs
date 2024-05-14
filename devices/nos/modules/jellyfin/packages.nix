{
  config,
  jellyfin-flake,
  pkgs,
  ...
}: let
  jellyPkgs =
    if config.nvidia.enableCUDA
    then jellyfin-flake.packages.${pkgs.system}.cudaPackages
    else jellyfin-flake.packages.${pkgs.system};
in {
  services.jellyfin = {
    package = jellyPkgs.jellyfin;
    webPackage = jellyPkgs.jellyfin-web;
    ffmpegPackage = jellyPkgs.jellyfin-ffmpeg;
  };

  environment.systemPackages = with config.services.jellyfin; [
    finalPackage
    webPackage
    ffmpegPackage
  ];
}
