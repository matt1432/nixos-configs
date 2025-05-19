{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-JrNSvzH2H1vjxblObj6MdVZv6QpA7zkKlJ3leuYbk6c=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
