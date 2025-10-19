pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:b34718b23370d19265f9e13ff28651f3258408360b4a13811184e45feff49456";
  hash = "sha256-I2po8j/K3ozxUCRx8NedRgyj7rdzXJPlYk6z87xasbQ=";
  finalImageName = imageName;
  finalImageTag = "13";
}
