pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:6f79f57738630af33352b410bbfac8746ac96ceb15d72d2861198bcb96df13c0";
  hash = "sha256-xNcTIbHirID0NgCrv7WGeI1LppiIFQKWXo/AFdSphAA=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
