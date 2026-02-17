pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:b6b4d0b75c699a2c94dfc5a94fe09f38630f3b67ab0e1653ede1b7ac8e13c197";
  hash = "sha256-e6yTp4buvSEB4t9ecSgy/zTfkd+O3ajc/0T+2mqB3NM=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
