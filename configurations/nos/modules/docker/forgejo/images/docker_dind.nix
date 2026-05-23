pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "docker";
  imageDigest = "sha256:6b9cd914eb9c6b342c040a49a27a5eb3804453bae6ecc90f7ff96133595a95e8";
  hash = "sha256-Y80zdGMx2vUHnUpF+dhr7539JTHqSF73cVNECixOP44=";
  finalImageName = imageName;
  finalImageTag = "dind";
}
