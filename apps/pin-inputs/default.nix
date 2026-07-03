{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-OQCY0UPAQQfKP2I2jxIv6/69oxf1Iiv+Upyu9X11scY=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
