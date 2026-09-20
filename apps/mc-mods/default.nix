{
  buildApp,
  nodejs_latest,
  ...
}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-DashXbIGb2bQD0Q9VKLOs1LOjnSxGrVRl33k8E5AgRc=";

  runtimeInputs = [
    nodejs_latest
  ];

  meta.description = ''
    Checks if a list of mods have a version available for a specific Minecraft
    version and a specific loader.
  '';
}
