{
  buildApp,
  callPackage,
  ...
}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-zl/UIwBQqpV89Rvagyq3mQDJxkWM0h1evtKg9TiTdiw=";

  runtimeInputs = [
    (callPackage ../../nixosModules/docker/updateImage.nix {})
  ];
}
