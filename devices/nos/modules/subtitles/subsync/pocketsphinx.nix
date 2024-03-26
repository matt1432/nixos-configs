{
  cmake,
  pkg-config,
  pocketsphinx-src,
  sphinxbase,
  stdenv,
  ...
}: let
  pyproject =
    (
      fromTOML (
        builtins.readFile "${pocketsphinx-src}/pyproject.toml"
      )
    )
    .project;
in
  stdenv.mkDerivation rec {
    name = "pocketsphinx";
    inherit (pyproject) version;

    src = pocketsphinx-src;

    buildInputs = [pkg-config];
    nativeBuildInputs = [cmake sphinxbase];

    postFixup = ''
      cp -ar ${src}/src/util $out/include
    '';
  }
