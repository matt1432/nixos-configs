{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-sR9bkRbBueKIQjlfRlWU4Nn7K8DqtdCS735/eKlfxkU=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
