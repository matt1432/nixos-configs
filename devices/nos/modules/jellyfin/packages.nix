{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) hasAttr optionals;
in {
  environment.systemPackages = [
    pkgs.jellyfin
    pkgs.jellyfin-ffmpeg

    (pkgs.jellyfin-web.overrideAttrs (_: o: {
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
