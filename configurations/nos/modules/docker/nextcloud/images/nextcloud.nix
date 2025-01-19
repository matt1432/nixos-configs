pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:4c898a6e3a17fcd3bcbe9d2450079a95581cfb9f0dbfca246c39bd60c77d123b";
  hash = "sha256-kK4F6UQVJm+r98/FH5uMG7VyVm5zzzmA7smc3IoDpFI=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
