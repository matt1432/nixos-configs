{
  # nix build inputs
  lib,
  fetchFromGitHub,
  makeWrapper,
  maven,
  # deps
  chromedriver,
  google-chrome,
  jdk21_headless,
  jmusicbot,
  jre_minimal,
  ...
}: let
  inherit (lib) concatStringsSep getExe;

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
          --output "$out"

      runHook postBuild
    '';
  });

  pname = "jmusicbot";
  version = "0.6.6";
in
  maven.buildMavenPackage {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "chrisb09";
      repo = "MusicBot";
      tag = version;
      hash = "sha256-nv1tI/Jwg4I3iYMc85Cojvc/gteu5C2+fUfbe6w0Dso=";
    };

    mvnHash = "sha256-U3+Iwe6PT5AKL8tN/r8kI//gbyroHDs6Xz6vnixMUEg=";

    nativeBuildInputs = [makeWrapper];

    postPatch = ''
      substituteInPlace ./src/main/java/com/jagrosh/jmusicbot/BotConfig.java \
          --replace-fail \
              'return chromePath.equals("AUTO") ? null : chromePath;' \
              'return "${getExe google-chrome}";' \
          --replace-fail \
              'return chromeDriverPath.equals("AUTO") ? null : chromeDriverPath;' \
              'return "${getExe chromedriver}";'
    '';

    installPhase = ''
      mkdir -p "$out/lib"
      install -Dm644 ./target/JMusicBot-${version}-All.jar "$out/lib/JMusicBot"

      makeWrapper ${jre}/bin/java "$out/bin/JMusicBot" \
        --add-flags "-Xmx1G -Dnogui=true -Djava.util.concurrent.ForkJoinPool.common.parallelism=1 -jar $out/lib/JMusicBot" \
        --suffix PATH : ${lib.makeBinPath [chromedriver google-chrome]}
    '';

    meta = {
      inherit (jmusicbot.meta) description license mainProgram;
      # https://github.com/NixOS/nixpkgs/pull/486721
      platforms = ["x86_64-linux"];
    };
  }
