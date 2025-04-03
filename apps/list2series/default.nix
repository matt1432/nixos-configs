{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-TXmob2BTSG6F02oi+2lRAFG115ItOOAXdnOjC2K37ec=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
