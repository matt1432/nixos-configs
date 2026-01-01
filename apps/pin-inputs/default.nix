{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-a/Lm+ORb+U16tM4HmvxjHdFjcUfiR4lKRIFCySX78YE=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
