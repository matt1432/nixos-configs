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

  jellyWeb = jellyPkgs.jellyfin-web.overrideAttrs (_: o: {
    # Inject skip intro button
    patches =
      [
        (pkgs.fetchpatch {
          name = "skipintro.patch";
          url = "https://pastebin.com/raw/EEgvReaw";
          hash = "sha256-kfvOz0ukDY09kkbmZi24ch5KWJsVcThNEVnjlk4sAC0=";
        })
      ]
      ++ optionals (hasAttr "patches" o) o.patches;

    # Enable backdrops by default. Not sure if it actually works
    postInstall = ''
      substituteInPlace $out/share/jellyfin-web/main.jellyfin.bundle.js \
        --replace-fail \
        'enableBackdrops:function(){return P}' \
        'enableBackdrops:function(){return _}'
    '';
  });

  jellyfinPkg = jellyPkgs.jellyfin.overrideAttrs (_: o: {
    # This was the only way I found to replace the jellyfin-web package
    preInstall = ''
      makeWrapperArgs+=(
        --add-flags "--ffmpeg ${jellyPkgs.jellyfin-ffmpeg}/bin/ffmpeg"
        --add-flags "--webdir ${jellyWeb}/share/jellyfin-web"
      )
    '';
  });
in {
  services.jellyfin.package = jellyfinPkg;

  environment.systemPackages = [
    jellyfinPkg
    jellyWeb
    jellyPkgs.jellyfin-ffmpeg
  ];
}
