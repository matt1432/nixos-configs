{
  # nix build inputs
  lib,
  fetchurl,
  # deps
  jmusicbot,
  jdk21_headless,
  jre_minimal,
  ...
}: let
  inherit (lib) concatStringsSep;

  jre_modules = [
    "java.se"
    "jdk.crypto.cryptoki"
  ];

  jre = (jre_minimal.override {jdk = jdk21_headless;}).overrideAttrs (o: {
    buildPhase = ''
      runHook preBuild

      # further optimizations for image size https://github.com/NixOS/nixpkgs/issues/169775
      jlink \
          --module-path ${jdk21_headless}/lib/openjdk/jmods \
          --add-modules ${concatStringsSep "," jre_modules} \
          --no-header-files \
          --no-man-pages \
          --output $out

      runHook postBuild
    '';
  });
in
  # FIXME: this fork doesn't work anymore
  (jmusicbot.override {jre_headless = jre;}).overrideAttrs (o: rec {
    version = "0.4.3.5";
    src = fetchurl {
      url = "https://github.com/xPrinny/MusicBot/releases/download/${version}/JMusicBot-${version}.jar";
      sha256 = "sha256-3hGqm6Ey4CHLSTEPvKmaPTwsoG5+jHS6W3zwjF3km8Q=";
    };
    meta = o.meta // {platforms = ["x86_64-linux"];};
  })
