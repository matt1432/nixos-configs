{
  trash-d-src,
  stdenv,
  dmd,
  dub,
  ronn,
  ...
}:
stdenv.mkDerivation {
  name = "trash";
  version = trash-d-src.shortRev;

  src = trash-d-src;

  buildInputs = [dub dmd ronn];

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
