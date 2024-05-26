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
    webPackage = jellyPkgs.jellyfin-web.overrideAttrs {
      postInstall = ''
        sed -E -i 's/enableBackdrops\:function\(\)\{return \_\}/enableBackdrops\:function\(\)\{return P\}/' $out/share/jellyfin-web/main.jellyfin.bundle.js
      '';
    };
    ffmpegPackage = jellyPkgs.jellyfin-ffmpeg;
  };

  environment.systemPackages = with config.services.jellyfin; [
    finalPackage
    webPackage
    ffmpegPackage
  ];
}
