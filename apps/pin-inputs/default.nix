{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-8reCDpSUbubvOD9u9DwGOXHmN2kEWVjNSdCIV6hJxxg=";

  runtimeInputs = [];

  meta.description = ''
    Takes a list of inputs to pin to their current rev in `flake.lock`.
  '';
}
