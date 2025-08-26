{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-FnMOlzpOiKsvmtJcEomFRme3wUEghUTbwzUK4s4OkjI=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
