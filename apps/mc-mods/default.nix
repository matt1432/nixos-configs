{
  buildApp,
  nodejs_latest,
  ...
}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-6Bei5W9JmxUN3ac47V9A/ixJxpIK4GOR0YBG2jOc47c=";

  runtimeInputs = [
    nodejs_latest
  ];

  meta.description = ''
    Checks if a list of mods have a version available for a specific Minecraft
    version and a specific loader.
  '';
}
