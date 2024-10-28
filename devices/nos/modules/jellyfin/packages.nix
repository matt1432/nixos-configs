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
        substituteInPlace $out/share/jellyfin-web/main.jellyfin.bundle.js --replace-fail \
            'enableBackdrops:function(){return L}' 'enableBackdrops:function(){return _}'
      '';
    };
    ffmpegPackage = jellyPkgs.jellyfin-ffmpeg;
  };

  environment.systemPackages = builtins.attrValues {
    inherit
      (config.services.jellyfin)
      finalPackage
      webPackage
      ffmpegPackage
      ;
  };
}
