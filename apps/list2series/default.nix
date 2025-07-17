{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-vHIi1PUSBD2BN32t0gz8BkpRDQXTJGao6SFh2HKuH1o=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
