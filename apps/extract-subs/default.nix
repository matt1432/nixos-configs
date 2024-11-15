{
  lib,
  buildNpmPackage,
  ffmpeg-full,
  makeWrapper,
  nodejs_latest,
  ...
}: let
  inherit (lib) concatMapStringsSep getBin;

  packageJSON = builtins.fromJSON (builtins.readFile ./package.json);
in
  buildNpmPackage rec {
    pname = packageJSON.name;
    inherit (packageJSON) version;

    src = ./.;
    npmDepsHash = "sha256-edIAvY03eA3hqPHjAXz8pq3M5NzekOAYAR4o7j/Wf5Y=";

    runtimeInputs = [
      ffmpeg-full
    ];
    nativeBuildInputs = [makeWrapper];

    postInstall = ''
      wrapProgram $out/bin/${pname} \
          --prefix PATH : ${concatMapStringsSep ":" (p: getBin p) runtimeInputs}
    '';

    nodejs = nodejs_latest;
    meta.mainProgram = pname;
  }
