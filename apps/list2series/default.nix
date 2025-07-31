{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-6ZiKpzreM2bb/IHq1tWt17SIunBDwDUBsRX+9Nlk8xE=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
