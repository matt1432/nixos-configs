{
  # nix build inputs
  lib,
  alive-server-src,
  buildNpmPackage,
  # update script deps
  nix-update-script,
  ...
}: let
  inherit (builtins) fromJSON readFile;

  package = fromJSON (readFile "${alive-server-src}/package.json");

  pname = "alive-server";
  version = "${package.version}+${alive-server-src.shortRev}";
in
  buildNpmPackage {
    inherit pname version;

    src = alive-server-src;

    npmDepsHash = "sha256-Sy12I9ELcu/Pcb/Bo1KsEXEbVSvTct5AQrzBVvve4dE=";

    dontNpmBuild = true;

    passthru.updateScript = nix-update-script {
      extraArgs = ["--no-src" "--url" "https://github.com/ljcp/alive-server" "--flake"];
    };

    meta = {
      mainProgram = pname;
      license = with lib.licenses; [mit];
      homepage = "https://github.com/tapio/live-server#readme";
      description = "simple development http server with live reload capability";
    };
  }
