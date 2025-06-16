{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-+UyN80ARC87ZmOejOgfeEVo4D3y3vicoqAhaG8Lk8eE=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
