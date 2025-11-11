{
  # nix build inputs
  lib,
  stdenv,
  makeWrapper,
  komf-src,
  # deps
  gradle_8,
  jdk17_headless,
  ...
}: let
  inherit (import ./version.nix) tag;

  pname = "komf";
  version = "${tag}+${komf-src.shortRev or "dirty"}";

  jdk = jdk17_headless;
  gradle = gradle_8.override {java = jdk;};
in
  stdenv.mkDerivation (finalAttrs: {
    inherit pname version;

    src = komf-src;

    gradleFlags = ["-Dorg.gradle.java.home=${jdk}"];

    gradleBuildTask = ":komf-app:shadowjar";
    gradleUpdateTask = finalAttrs.gradleBuildTask;

    mitmCache = gradle.fetchDeps {
      pkg = finalAttrs.finalPackage;
      data = ./deps.json;
      silent = false;
      useBwrap = false;
    };

    nativeBuildInputs = [
      gradle
      makeWrapper
    ];
    buildInputs = [
      jdk
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/{bin,share/komf}
      cp komf-app/build/libs/*.jar $out/share/komf/komf.jar

      makeWrapper ${jdk}/bin/java $out/bin/${pname} \
        --add-flags "-jar $out/share/komf/komf.jar" \
        --prefix PATH : "$PATH"

      runHook postInstall
    '';

    passthru.updateScript = ./update.sh;

    meta = {
      mainProgram = pname;
      license = lib.licenses.mit;
      homepage = "https://github.com/Snd-R/komf";
      description = ''
        Komf is a tool that fetches metadata and thumbnails for your digital comic book library.
      '';
    };
  })
