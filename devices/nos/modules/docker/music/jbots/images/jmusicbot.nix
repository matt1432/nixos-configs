# Locked
pkgs: let
  dname = "jmusicbot-docker";
  dtag = pkgs.jmusicbot.version;

  jre_modules = [
    "java.se"
    "jdk.crypto.cryptoki"
  ];
  jre =
    (pkgs.jre_minimal.overrideAttrs {
      buildPhase = ''
        runHook preBuild

        # further optimizations for image size https://github.com/NixOS/nixpkgs/issues/169775
        jlink --module-path ${pkgs.jdk11_headless}/lib/openjdk/jmods --add-modules ${pkgs.lib.concatStringsSep "," jre_modules} --no-header-files --no-man-pages --compress=2 --output $out

        runHook postBuild
      '';
    })
    .override {jdk = pkgs.jdk11_headless;};

  jmusicbot =
    (pkgs.jmusicbot.overrideAttrs rec {
      version = "0.4.3.1";
      src = pkgs.fetchurl {
        url = "https://github.com/xPrinny/MusicBot/releases/download/${version}/JMusicBot-${version}.jar";
        sha256 = "sha256-35JdmLArl9ssYDpdKDsBx3lu6TCN1JiCBI34W+uyVJ0=";
      };
      meta.platforms = ["x86_64-linux"];
    })
    .override {jre_headless = jre;};
in
  pkgs.dockerTools.buildLayeredImage {
    name = dname;
    tag = dtag;
    config = {
      created = "now";
      Cmd = ["${jmusicbot}/bin/JMusicBot"];
      WorkingDir = "/jmb/config";
      Volumes."/jmb/config" = {};
    };
  }
