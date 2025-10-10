final: prev: {
  # FIXME: remove when 1.1.0 reaches nixos-unstable
  whoogle-search = prev.whoogle-search.overridePythonAttrs (o: rec {
    version = "1.1.0";

    src = final.fetchPypi {
      pname = "whoogle_search";
      inherit version;
      hash = "sha256-2whW58feLNqBvarqbMEfoMUz8U+1L3iLl5OMtX3svW4=";
    };

    dependencies = o.dependencies ++ (with final.python3Packages; [cachetools h2 httpx]);
  });
}
