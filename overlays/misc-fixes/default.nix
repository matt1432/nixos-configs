final: prev: {
  # FIXME: https://pr-tracker.nelim.org/?pr=443349
  spotifywm = prev.spotifywm.overrideAttrs (o: {
    buildInputs = o.buildInputs ++ [final.libxcb];
  });

  # FIXME: https://pr-tracker.nelim.org/?pr=445274
  whoogle-search = prev.whoogle-search.overridePythonAttrs (o: rec {
    version = "0.9.4";
    src = final.fetchPypi {
      pname = "whoogle_search";
      inherit version;
      hash = "sha256-EvmNDU1hRUIy+CTwECLzIdcEjzcJgiiFYd2iMy0wDG0=";
    };
  });
}
