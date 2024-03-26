{
  stdenv,
  python3Packages,
  pokemon-colorscripts-src,
  ...
}:
stdenv.mkDerivation {
  name = "pokemon-colorscripts";
  version = pokemon-colorscripts-src.shortRev;

  src = pokemon-colorscripts-src;

  propagatedBuildInputs = with python3Packages; [
    python
  ];

  installPhase = ''
    mkdir -p $out/pokemon-colorscripts $out/bin

    cp -rf colorscripts $out/pokemon-colorscripts
    cp pokemon.json $out/pokemon-colorscripts

    cp pokemon-colorscripts.py $out/pokemon-colorscripts

    ln -s $out/pokemon-colorscripts/pokemon-colorscripts.py $out/bin/pokemon-colorscripts
  '';
}
