{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) hasAttr optionals;

  jellyPkgs =
    if config.nvidia.enableCUDA
    then pkgs.cudaPackages.pkgs
    else pkgs;
in {
  services.jellyfin.package = jellyPkgs.jellyfin;

  environment.systemPackages = [
    jellyPkgs.jellyfin
    jellyPkgs.jellyfin-ffmpeg

    (jellyPkgs.jellyfin-web.overrideAttrs (_: o: {
      patches =
        [
          (pkgs.fetchpatch {
            name = "skipintro.patch";
            url = "https://pastebin.com/raw/EEgvReaw";
            hash = "sha256-kfvOz0ukDY09kkbmZi24ch5KWJsVcThNEVnjlk4sAC0=";
          })
        ]
        ++ optionals (hasAttr "patches" o) o.patches;

      # Enable backdrops by default
      postInstall = ''
        sed -E -i 's/enableBackdrops\:function\(\)\{return P\}/enableBackdrops\:function\(\)\{return \_\}/' $out/share/jellyfin-web/main.jellyfin.bundle.js
      '';
    }))
  ];
}
