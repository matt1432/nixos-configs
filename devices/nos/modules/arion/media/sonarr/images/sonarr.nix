pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:878f8538c5becb75bae4e2f010aaee85b4ec3792acedbeaf639e800995b6e6fe";
  sha256 = "086fikin7612vpfivg72yl5khnz7lxhqcdc9nfrirz29nb8g82n5";
  finalImageName = "ghcr.io/linuxserver/sonarr";
  finalImageTag = "latest";
}
