{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-7KG3chQa9G7M/QDVpeQtLylsqyAe2Ns+nKS/kSIZM9g=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
