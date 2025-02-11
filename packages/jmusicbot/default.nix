{
  # nix build inputs
  lib,
  fetchurl,
  # deps
  jmusicbot,
  jdk11_headless,
  jre_minimal,
  ...
}: let
  inherit (lib) concatStringsSep;

  jre_modules = [
    "java.se"
    "jdk.crypto.cryptoki"
  ];

  jre = (jre_minimal.override {jdk = jdk11_headless;}).overrideAttrs (o: {
    buildPhase = ''
      runHook preBuild

      # further optimizations for image size https://github.com/NixOS/nixpkgs/issues/169775
      jlink \
          --module-path ${jdk11_headless}/lib/openjdk/jmods \
          --add-modules ${concatStringsSep "," jre_modules} \
          --no-header-files \
          --no-man-pages \
          --compress=2 \
          --output $out

      runHook postBuild
    '';
  });
in
  (jmusicbot.override {jre_headless = jre;}).overrideAttrs (o: rec {
    version = "0.4.3.3";
    src = fetchurl {
      url = "https://github.com/xPrinny/MusicBot/releases/download/${version}/JMusicBot-${version}.jar";
      sha256 = "sha256-NYUT0FhSIqt+SECOKdnqBNQ37qinkwNWIzpXw8+7FXg=";
    };
    meta = o.meta // {platforms = ["x86_64-linux"];};
  })
