pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:d35fe6e6bd8d17d66dc383e18f68ce73bc9772cd3121eaa96e2c7944fe17d337";
  hash = "sha256-uevDpBdtWlXSYwhYV7xPn2riKTMDdUB+7EnrCzYOMOk=";
  finalImageName = imageName;
  finalImageTag = "14";
}
