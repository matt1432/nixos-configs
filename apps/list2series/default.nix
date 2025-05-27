{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-dq8e3Z+J45AHQfg9Uj+L60HHI074cA8m0C4R2j3Ehf4=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
