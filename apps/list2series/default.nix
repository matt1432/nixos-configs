{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-5HsY4B6TP/t6+ILlo3pYjrKBOhGKa0sMPuVlBIXB5gw=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
