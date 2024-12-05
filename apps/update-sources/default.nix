{
  buildApp,
  callPackage,
  nodejs_latest,
  prefetch-npm-deps,
  ...
}:
buildApp {
  src = ./.;
  npmDepsHash = "sha256-eZTHpejE/OjmQSXJie8u+AZWRw+LoEhLj8Ppsl7YZJU=";

  runtimeInputs = [
    nodejs_latest
    prefetch-npm-deps
    (callPackage ../../nixosModules/docker/updateImage.nix {})
  ];
}
