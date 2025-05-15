{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-XnVlRAyfDkR/LT4SY0uTQlrQARwGGpLbTxgecaBygi0=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
