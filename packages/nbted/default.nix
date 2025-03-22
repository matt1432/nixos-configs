{
  # nix build inputs
  lib,
  rustPlatform,
  fetchFromGitHub,
  ...
}: let
  pname = "nbted";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "C4K3";
    repo = pname;
    tag = version;
    hash = "sha256-5gCxTFjI3WDC9+F9i4I2g17+wHWnQHjC4Hurj5CMhB4=";
  };
in
  rustPlatform.buildRustPackage {
    inherit pname src version;

    cargoLock.lockFile = "${src}/Cargo.lock";

    env.OUT_DIR = "$out";

    patchPhase = ''
      export OUT_DIR=$(mktemp -d)

      rm ./build.rs
      echo '"${version}"' > $OUT_DIR/git-revision.txt
      substituteInPlace ./Cargo.toml --replace-fail "build = \"build.rs\"" ""
    '';

    meta = {
      mainProgram = pname;
      license = lib.licenses.cc0;
      homepage = "https://github.com/C4K3/nbted";
      description = ''
        Command-line NBT editor written in Rust. It does precisely one thing: convert NBT files to
        a pretty text format, and reverse the pretty text format back into NBT.
      '';
    };
  }
