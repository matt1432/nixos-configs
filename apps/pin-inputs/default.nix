{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-XRKfHRHU6NfmmKqf+DxI3BMDIzfJcEjVBGOJD77JyLA=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
