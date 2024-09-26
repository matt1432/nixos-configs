{
  lib,
  buildNpmPackage,
  callPackage,
  makeWrapper,
  nodejs_latest,
  ...
}: let
  inherit (lib) concatMapStringsSep getBin;
  inherit (builtins) readFile fromJSON;

  packageJSON = fromJSON (readFile ./package.json);
in
  buildNpmPackage rec {
    pname = packageJSON.name;
    inherit (packageJSON) version;

    src = ./.;
    npmDepsHash = "sha256-nYdr7jbe5wW9Rg0G4l5jbZg8G0o8DioeSGpx+8e0VZI=";

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
