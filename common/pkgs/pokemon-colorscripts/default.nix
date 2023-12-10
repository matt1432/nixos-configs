{
  stdenv,
  python3Packages,
  fetchFromGitLab,
}:
stdenv.mkDerivation {
  name = "pokemon-colorscripts";

  propagatedBuildInputs = with python3Packages; [
    python
  ];

  src = fetchFromGitLab {
    owner = "phoneybadger";
    repo = "pokemon-colorscripts";
    rev = "0483c85b93362637bdd0632056ff986c07f30868";
    hash = "sha256-rj0qKYHCu9SyNsj1PZn1g7arjcHuIDGHwubZg/yJt7A=";
  };

  installPhase = ''
    mkdir -p $out/pokemon-colorscripts $out/bin

    cp -rf colorscripts $out/pokemon-colorscripts
    cp pokemon.json $out/pokemon-colorscripts

    cp pokemon-colorscripts.py $out/pokemon-colorscripts

    ln -s $out/pokemon-colorscripts/pokemon-colorscripts.py $out/bin/pokemon-colorscripts
  '';
}
