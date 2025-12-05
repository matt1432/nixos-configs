{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-QuXgZnDyPlLhK6n1Xrfh1oBVF76abKdRpwfohkX9DxA=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
