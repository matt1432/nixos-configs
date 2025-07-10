{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-r0ubklflJJ5AWBUTAR+qnhta8zFNhLgnO2xfy/Oiz5g=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
