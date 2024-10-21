{
  lib,
  buildNpmPackage,
  callPackage,
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
    npmDepsHash = "sha256-hNXuZi3kgst0wBzoOwNAthEXW5MrafDD6D3Zwzp0S78=";

    runtimeInputs = [
      (callPackage ../../nixosModules/docker/updateImage.nix {})
    ];
    nativeBuildInputs = [makeWrapper];

    postInstall = ''
      wrapProgram $out/bin/${pname} \
          --prefix PATH : ${concatMapStringsSep ":" (p: getBin p) runtimeInputs}
    '';

    nodejs = nodejs_latest;
    meta.mainProgram = pname;
  }
