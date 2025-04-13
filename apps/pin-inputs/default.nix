{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-521CPFrk38VTlNsufxkf0JXVu4I/hDGCTwd9uxedRVo=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
