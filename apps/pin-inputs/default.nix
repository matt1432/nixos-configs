{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-aLhrUC6cael2GOva613MUO4Sc4PLEw9kTLhNmATuphU=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
