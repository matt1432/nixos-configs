{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-pDtUWeFbQ9UgJM8M0Y2WshoJfORdzcRyblge89t9klA=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
