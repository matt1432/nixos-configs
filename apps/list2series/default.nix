{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-jZc+bjYzI9ef5lw2PGp4CDa2nbTTJ2nOZeWt6ftRgww=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
