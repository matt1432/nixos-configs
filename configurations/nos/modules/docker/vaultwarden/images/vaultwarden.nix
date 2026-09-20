pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "quay.io/vaultwarden/server";
  imageDigest = "sha256:1587c45feaa479f1f5e8af3b00eded36bff77bcf1880cf8dbf0541706dd470e0";
  hash = "sha256-H/QOQWyyjX7em5eX+8u7B4vit4RAeS46r4e4/JgXBRc=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
