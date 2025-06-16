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
  inherit (lib) concatStringsSep elem filter getExe;

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

  pname = "jmusicbot";
  version = "0.4.12";
in
  maven.buildMavenPackage {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "matt1432";
      repo = "MusicBot";
      rev = "6d86eea5718c6257aae7008ee687f4a3d987d0df";
      hash = "sha256-nGa6Yv+301++7+/o2XK4WBUCeS9UpCAKxa3WaujiRG0=";
    };

    mvnHash = "sha256-H8BeH9WcGi7UiINl51UoA0054EvvmmVHAIElfdS84hw=";

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
      mkdir -p $out/lib
      install -Dm644 ./target/JMusicBot-${version}-All.jar $out/lib/JMusicBot

      makeWrapper ${jre}/bin/java $out/bin/JMusicBot \
        --add-flags "-Xmx1G -Dnogui=true -Djava.util.concurrent.ForkJoinPool.common.parallelism=1 -jar $out/lib/JMusicBot" \
        --suffix PATH : ${lib.makeBinPath [chromedriver google-chrome]}
    '';

    meta = {
      inherit (jmusicbot.meta) description license mainProgram;
      platforms = filter (x: elem x google-chrome.meta.platforms) jmusicbot.meta.platforms;
    };
  }
