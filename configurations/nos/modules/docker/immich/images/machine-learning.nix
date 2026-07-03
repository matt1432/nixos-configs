pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:cb2128c5cbc554fdaa2a036fb4419c808a9f3e0f27170e569dd9e727243da909";
  hash = "sha256-npPILQWKgR7DN2IFc94i75FE6t3ShROfgNV4mT6aPVk=";
  finalImageName = imageName;
  finalImageTag = "release";
}
