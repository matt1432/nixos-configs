{buildApp, ...}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-df+aDVrrktLD8E0ZI0MKwZ7OczliC3OBbK3lZbIuATM=";

  runtimeInputs = [];

  meta.description = ''
    Converts a Komga read list into a comics series for reading with mihon.
  '';
}
