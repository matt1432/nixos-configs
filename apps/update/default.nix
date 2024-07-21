{
  lib,
  system,
  buildNpmPackage,
  callPackage,
  makeWrapper,
  mozilla-addons-to-nix,
  nodejs_latest,
  ...
}: let
  inherit (lib) concatMapStringsSep getBin;
  inherit (builtins) readFile fromJSON;

  packageJSON = fromJSON (readFile ./package.json);
  pname = packageJSON.name;
in
  buildNpmPackage rec {
    name = pname;
    inherit (packageJSON) version;

    src = ./.;
    npmDepsHash = "sha256-qpnQSJNl68LrsU8foJYxdBXpoFj7VKQahC9DFmleWTs=";

    runtimeInputs = [
      (callPackage ../../modules/arion/updateImage.nix {})
      mozilla-addons-to-nix.packages.${system}.default
    ];
    nativeBuildInputs = [makeWrapper];

    postInstall = ''
      wrapProgram $out/bin/${pname} \
        --prefix PATH : ${concatMapStringsSep ":" (p: getBin p) runtimeInputs}
    '';

    nodejs = nodejs_latest;
    meta.mainProgram = pname;
  }
