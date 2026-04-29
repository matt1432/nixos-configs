pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/cleanuparr/cleanuparr";
  imageDigest = "sha256:ff3f64c08f7296ab467d5baa239cec6727c0739da43b05be8eba4741c35ef2c9";
  hash = "sha256-9wq3rmPMNEGlnRU4yD3KX+3L5hKo+JSxD6oDYAWv9gw=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
