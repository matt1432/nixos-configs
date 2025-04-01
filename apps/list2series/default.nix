{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-9iQ+Ke/Jq2VgSToVciQLuPDuedBF6zIRrdP0FKByQxs=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
