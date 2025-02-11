{
  # nix build inputs
  lib,
  stdenv,
  fetchFromGitHub,
  # deps
  dmd,
  dub,
  just,
  scdoc,
  ...
}: let
  pname = "trash";
  version = "20";
in
  stdenv.mkDerivation {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "rushsteve1";
      repo = "trash-d";
      rev = version;
      hash = "sha256-x76kEqgwJGW4wmEyr3XzEXZ2AvRsm9ewrfjRjIsOphw=";
    };

    nativeBuildInputs = [
      just
    ];

    buildInputs = [
      dmd
      dub
      scdoc
    ];

    buildPhase = ''
      # https://github.com/svanderburg/node2nix/issues/217#issuecomment-751311272
      export HOME=$(mktemp -d)

      just release manpage
    '';

    installPhase = ''
      mkdir -p $out/{bin,man/man1}

      cp -a ./build/trash $out/bin
      cp -a ./build/trash.1 $out/man/man1
    '';

    meta = {
      mainProgram = "trash";
      license = with lib.licenses; [mit];
      platforms = [
        "x86_64-linux"
        "i686-linux"
        "x86_64-darwin"
      ];
      homepage = "https://github.com/rushsteve1/trash-d";
      description = ''
        A near drop-in replacement for `rm` that uses the
        [FreeDesktop trash bin](https://specifications.freedesktop.org/trash-spec/trashspec-latest.html).
      '';
    };
  }
