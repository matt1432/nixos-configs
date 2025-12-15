{
  buildApp,
  nodejs_latest,
  ...
}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-uFkwXzEmRsseJypjQZhsQc79xon3qAGxQTbh9qhzdnU=";

  runtimeInputs = [
    nodejs_latest
  ];

  meta.description = ''
    Checks if a list of mods have a version available for a specific Minecraft
    version and a specific loader.
  '';
}
