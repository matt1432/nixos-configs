{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-VxwS3UcyJrzDj+6Hp8sfDdFwnR7jc5CDMhnpH876NaU=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
