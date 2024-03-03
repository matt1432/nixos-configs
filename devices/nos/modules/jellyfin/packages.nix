{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) hasAttr optionals;

  isNvidia = config.hardware.nvidia.modesetting.enable;
  jellyPkgs =
    if isNvidia
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
    }))
  ];
}
