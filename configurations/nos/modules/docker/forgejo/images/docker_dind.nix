pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "docker";
  imageDigest = "sha256:7dcdfc4a20246236f558175182ccace1eb15a41bd3eb119dd2284f393498b7c1";
  hash = "sha256-WrIxy4I2Z6W6AvGuSDE6JD3NPHBiR27L9bkLocE9XM0=";
  finalImageName = imageName;
  finalImageTag = "dind";
}
