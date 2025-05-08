{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-UR2hivKGRenJ1W0iEqiyE9JSEhrn6yRu3gFCZAv5rBw=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
