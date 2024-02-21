pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:33211bbedb8af1a24c1416617c1e2504d6011a18d6ed83a4b8023647bfbfe58a";
  sha256 = "02vknd06jrp951c1ki110f8vx3hdmc7xldpkqkzyr8cxx4qb3hrx";
  finalImageName = "ghcr.io/immich-app/immich-machine-learning";
  finalImageTag = "v1.95.1";
}
