{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-Ipk5BUgqXXtowsoHwWEzy6zxH8kfJJ42sP2+g+NgxjI=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
