{
  # nix build inputs
  lib,
  fetchFromGitHub,
  rustPlatform,
  ...
}: let
  inherit (builtins) fromTOML readFile;
in
  rustPlatform.buildRustPackage rec {
    pname = "forgejo-guardian";
    version = (fromTOML (readFile "${src}/Cargo.toml")).package.version;

    src = fetchFromGitHub {
      owner = "TheAwiteb";
      repo = pname;
      rev = "d7c6748b9e45dfa30a5aa076a2c0d0e8bfceea6f";
      sha256 = "sha256-i5vSO4SsPUaFJJHuKqG3IdRTTtYm2tUnvNL4+VLn34g=";
    };

    cargoLock.lockFile = "${src}/Cargo.lock";

    meta = {
      mainProgram = pname;
      license = with lib.licenses; [agpl3Only];
      homepage = "https://git.4rs.nl/awiteb/forgejo-guardian";
      description = ''
        `forgejo-guardian` is a simple guardian for your Forgejo instance,
        it will ban users based on certain regular expressions (regex) and
        alert the admins about them.
      '';
    };
  }
