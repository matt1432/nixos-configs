pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:b9f6b8ff03b62f3cfd9d9ba3fe56226a9991c79d3fb46fd46536263bf02be553";
  hash = "sha256-yBHpZ0Zt0X94Skr5z0IoFq8d4WbSMWXSG8HWbhwG3vE=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
