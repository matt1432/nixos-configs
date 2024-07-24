pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/gethomepage/homepage";
  imageDigest = "sha256:e23fcd332ecf927fe5c0149142040236b17686916004566c149eef06eb6f8d75";
  sha256 = "0z61nlv67ladznsa5cq2ial7dsjwfrdfkgs8a16h9bppz1apa2bf";
  finalImageName = "ghcr.io/gethomepage/homepage";
  finalImageTag = "latest";
}
