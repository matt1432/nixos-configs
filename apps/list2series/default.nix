{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-Awymm9YdpCLWto9m1csQTIsFDFPaGNg800ecEFPoT18=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
