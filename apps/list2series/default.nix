{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-Kh9xvY3QpxCzhr/xRdlrRphHr7BeyCR65t1zaP8v4IM=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
