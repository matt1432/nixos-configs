{
  # nix build inputs
  lib,
  stdenv,
  trash-d-src,
  # deps
  dmd,
  dub,
  ronn,
  ...
}: let
  inherit (builtins) fromJSON readFile;
  tag = (fromJSON (readFile "${trash-d-src}/dub.json")).version;

  pname = "trash";
  version = "${tag}+${trash-d-src.shortRev}";
in
  stdenv.mkDerivation {
    inherit pname version;

    src = trash-d-src;

    buildInputs = [
      dub
      ronn
      dmd
    ];

    buildPhase = ''
      # https://github.com/svanderburg/node2nix/issues/217#issuecomment-751311272
      export HOME=$(mktemp -d)

      dub build
    '';

    installPhase = ''
      mkdir -p $out/bin $out/man/man1

      cp -a ./build/trash $out/bin/

      ronn --roff --pipe MANUAL.md > $out/man/man1/trash.1
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
