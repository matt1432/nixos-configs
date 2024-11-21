{
  buildApp,
  callPackage,
  ...
}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-MF5z9QGOdxUKWDP7S4wdszgLrh6f5UyFb9tCn3QSH0k=";

  runtimeInputs = [
    (callPackage ../../nixosModules/docker/updateImage.nix {})
  ];
}
