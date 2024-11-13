pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:1462206286d1769c499e0f15f4998c9a518a330cacd4cf9c8206904f5dcfc131";
  sha256 = "13vclyfz5248l0fd9v85ki7cnh99fd4zpwk2g5sdc3v6ajrsb5yb";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
