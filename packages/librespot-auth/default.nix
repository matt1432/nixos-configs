{
  # nix build inputs
  lib,
  fetchFromGitHub,
  makeWrapper,
  rustPlatform,
  # deps
  openssl,
  pkg-config,
  ...
}:
rustPlatform.buildRustPackage rec {
  pname = "librespot-auth";
  version = "0.1.1";

  # deprecated https://github.com/dspearson/librespot-auth
  src = fetchFromGitHub {
    owner = "dspearson";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-IbbArRSKpnljhZSgL0b3EjVzKWN7bk6t0Bv7TkYr8FI=";
  };

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
    outputHashes = {
      "librespot-core-0.5.0-dev" = "sha256-7HrA1hWEy5lliwgJ9amJy+Kd8lB50b3q2niaFWWwcYE=";
    };
  };

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    openssl
  ];

  meta = {
    mainProgram = pname;
    license = with lib.licenses; [isc];
    homepage = "https://github.com/dspearson/librespot-auth";
    description = ''
      A simple program for populating a credentials.json via Spotify's
      zeroconf authentication.
    '';
  };
}
