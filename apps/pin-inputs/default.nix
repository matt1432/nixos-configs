{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-EA/8KcXt+yE/QlrNspZjFRizPhqoOMJ9m3fOt1TrhTU=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
