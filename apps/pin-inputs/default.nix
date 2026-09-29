{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-8Rd9ZZaykbSaSwDeIwP9z/dZE25BK9M6yl04zqyJd90=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
