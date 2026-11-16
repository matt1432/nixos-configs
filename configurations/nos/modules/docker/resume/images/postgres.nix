pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:2ea8630df176ad090ec92136dee850397c5af8781e4bcf2e4162593691c61bbc";
  hash = "sha256-yBHpZ0Zt0X94Skr5z0IoFq8d4WbSMWXSG8HWbhwG3vE=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
