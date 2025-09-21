{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-V1N93zvbqlsDuZOmYD6tD1yObZVSEq3uV3y/Q8GR+9U=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
