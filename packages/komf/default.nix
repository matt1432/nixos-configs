{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jre,
  ...
}: let
  pname = "komf";
  version = "1.3.0";
in
  stdenv.mkDerivation {
    inherit pname version;

    src = fetchurl {
      url = "https://github.com/Snd-R/${pname}/releases/download/${version}/${pname}-${version}.jar";
      hash = "sha256-6TR6NQnms/iqieRUSniEk2iLaQo/1mC1e1OWe8skNf8=";
      name = "${pname}-${version}.jar";
    };

    nativeBuildInputs = [makeWrapper];
    buildInputs = [
      jre
    ];

    dontUnpack = true;

    installPhase = ''
      runHook preInstall

      mkdir -p "$prefix/bin"

      makeWrapper ${jre}/bin/java $out/bin/${pname} \
        --add-flags "-jar $src" \
        --prefix PATH : "$PATH"

      runHook postInstall
    '';

    meta = {
      mainProgram = pname;
      license = lib.licenses.mit;
      homepage = "https://github.com/Snd-R/komf";
      sourceProvenance = with lib.sourceTypes; [binaryBytecode];
      description = ''
        komf is a tool that fetches metadata and thumbnails for your digital comic book library.
      '';
    };
  }
