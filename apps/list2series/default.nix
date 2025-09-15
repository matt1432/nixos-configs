{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-h6jb4/dDL2b9lIZK8VwoPeiV766CRvAO2Nfq4iSziAc=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
