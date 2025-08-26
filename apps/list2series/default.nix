{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-sNRqI2q+hcmv+5H2WjLB7z8kWZIKg/3szE1zAMSmCVk=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
