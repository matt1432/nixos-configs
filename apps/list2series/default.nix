{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-GrGSXKAH8w068rIOFwmQoM1Zn68ESkazBiDaoE0mrQw=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
