{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-adSDDSKoF9TpoV/K9SJJv108KJMF5Kc+lpuigBPn9tg=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
