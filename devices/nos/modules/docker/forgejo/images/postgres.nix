pkgs:
pkgs.dockerTools.pullImage {
  imageName = "postgres";
  imageDigest = "sha256:09f24db0563ca0463bad203ffd584b6e48f8f87624fe75ab3df0841c8b3ef049";
  sha256 = "0qwjsfq7h5myqfahb9fz0xs4fg1fylrjlyv6ic72hyryhanmh46f";
  finalImageName = "postgres";
  finalImageTag = "14";
}
