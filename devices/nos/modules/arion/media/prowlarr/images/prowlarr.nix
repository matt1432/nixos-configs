pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:0dbc7f087efdfe682f75a7468d8ac6688595463a0b5656459295effd56469909";
  sha256 = "1akbqirip425cm1w48g9yvyz23226w747f3zzhwgs0xb31hcv4j0";
  finalImageName = "ghcr.io/linuxserver/prowlarr";
  finalImageTag = "latest";
}
