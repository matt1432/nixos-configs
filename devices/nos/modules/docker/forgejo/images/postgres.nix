pkgs:
pkgs.dockerTools.pullImage {
  imageName = "postgres";
  imageDigest = "sha256:e3cc76b6d4dfc8f3547641d67053092e7c108e03ab159c00b48fa8d891e2f7b4";
  sha256 = "0qwjsfq7h5myqfahb9fz0xs4fg1fylrjlyv6ic72hyryhanmh46f";
  finalImageName = "postgres";
  finalImageTag = "14";
}
