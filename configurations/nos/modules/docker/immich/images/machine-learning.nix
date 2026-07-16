pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:d76fe88b69282c09a97eac4f82dafa82cfd77bce274bc742591cde974f87dacb";
  hash = "sha256-a+XjBjhMxCrG9pLByGjAdSeUSllsTOxobi3Os8UvCe0=";
  finalImageName = imageName;
  finalImageTag = "release";
}
