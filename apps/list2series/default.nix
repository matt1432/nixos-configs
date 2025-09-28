{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-7LqajiD0qz7raslJ4R0sUL1OXDOTTHSakRkM1kNxesc=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
