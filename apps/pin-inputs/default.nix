{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-BUx0PwxhNlUAbPmjmgU25AIskqzPM3tgIHhuoV7d4fQ=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
