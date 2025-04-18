{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-lFAf1jUqonnOtKqTi1rOX/2He0fA/uC3i09GS1ajDPE=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
