pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:161b1ec8af9e0478797cfd75ea857c7e55af271fa7cea103cb30ab1ba5b418d8";
  hash = "sha256-3nc3tq1XsjNujI3Bif4ec0p8DT84p/e9ozs/icAUBdE=";
  finalImageName = imageName;
  finalImageTag = "release";
}
