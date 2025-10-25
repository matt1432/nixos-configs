{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-FRZTzm7q5sOuK6M6Oa7ioM3cnt1+b5MYExbBaA4gw0E=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
