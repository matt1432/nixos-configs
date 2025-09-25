final: prev: {
  # FIXME: missing dep
  spotifywm = prev.spotifywm.overrideAttrs (o: {
    buildInputs = o.buildInputs ++ [final.libxcb];
  });

  # FIXME: remove when it reaches nixpkgs
  whoogle-search = prev.whoogle-search.overridePythonAttrs (o: rec {
    version = "0.9.4";
    src = final.fetchPypi {
      pname = "whoogle_search";
      inherit version;
      hash = "sha256-EvmNDU1hRUIy+CTwECLzIdcEjzcJgiiFYd2iMy0wDG0=";
    };
  });
}
