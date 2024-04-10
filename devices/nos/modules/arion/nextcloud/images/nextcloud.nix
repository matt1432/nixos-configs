pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nextcloud";
  imageDigest = "sha256:44fa4c8a9e468f234da40df6ad9067440090072206f03ff66eaf6ddfaf697b78";
  sha256 = "1lm6gbgw60dg3wfa3c0wd8lsjyp12sivh6mv88acp0hbrfnl2d01";
  finalImageName = "nextcloud";
  finalImageTag = "fpm";
}
