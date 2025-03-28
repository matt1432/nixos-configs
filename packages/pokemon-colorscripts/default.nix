{
  # nix build inputs
  mkVersion,
  stdenv,
  pokemon-colorscripts-src,
  # deps
  python3Packages,
  ...
}:
stdenv.mkDerivation {
  pname = "pokemon-colorscripts";
  version = mkVersion pokemon-colorscripts-src;

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

  meta = {
    homepage = "https://gitlab.com/phoneybadger/pokemon-colorscripts";
    description = ''
      A script to print out images of pokemon to the terminal.
    '';
  };
}
