{
  stdenv,
  fetchFromGitHub,
  dmd,
  dub,
  ronn,
  ...
}:
stdenv.mkDerivation {
  name = "trash";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "rushsteve1";
    repo = "trash-d";
    rev = "d88bb672612761c8e299e717857bf9c85a903e99";
    hash = "sha256-oPxeoEqOYf6DCg5rJxINqAIlMbxqzAJcZDUY/EzADzY=";
  };

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
