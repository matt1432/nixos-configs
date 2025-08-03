{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-rKHDZl7v1IgNXoUFcrOhIUpDKQz/rD68LzhOiZoWZTY=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
