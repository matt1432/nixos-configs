{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-PIgtmZFmsxamXdcuekAdM+nbVe1faNxT040fnQd186U=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
