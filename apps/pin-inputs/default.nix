{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-WbtaM4DceAjkycZsC6xDqczqWOj8g8O3BkDYelvSPrM=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
