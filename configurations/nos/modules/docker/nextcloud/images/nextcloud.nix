pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:1b7786935321e01a689affccb48a5845ed800184aa50c1b0c50d4aa75693e27f";
  hash = "sha256-xNcTIbHirID0NgCrv7WGeI1LppiIFQKWXo/AFdSphAA=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
