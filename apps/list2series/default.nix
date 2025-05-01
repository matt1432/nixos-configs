{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-z8+TtsjD1ggpokfwYWcHH7pPL5dTSA062FD64GvcMAU=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
