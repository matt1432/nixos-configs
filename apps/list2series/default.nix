{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-53xCN/3vr+nSGlukdo1AihXh4iM+eJhFU+QZMSxZ7WA=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
