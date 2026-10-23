pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:5b28c9352c8374b8a1ed96fbdd8d6755fea6e43510ec43fdf6538aa02ea40f56";
  hash = "sha256-LvZVppdmbX3zUlH8J+AN++Ri489xtB07ITnca9H8SwA=";
  finalImageName = imageName;
  finalImageTag = "release";
}
