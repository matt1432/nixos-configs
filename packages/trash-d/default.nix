{
  dmd,
  dub,
  trash-d-src,
  ronn,
  stdenv,
  ...
}: let
  inherit (builtins) fromJSON readFile;

  tag = (fromJSON (readFile "${trash-d-src}/dub.json")).version;
in
  stdenv.mkDerivation {
    pname = "trash";
    version = "${tag}+${trash-d-src.shortRev}";

    src = trash-d-src;

    buildInputs = [
      dub
      ronn

      # FIXME: dmd doesn't build on latest nixos-unstable. make issue?
      # FIXME: `config.nixpkgs.overlays` don't seem to apply on `self.packages` or `self.legacyPackages`
      (dmd.overrideAttrs (o: {
        postPatch =
          o.postPatch
          + ''
            rm dmd/compiler/test/fail_compilation/needspkgmod.d
          '';
      }))
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
  }
