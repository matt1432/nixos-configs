pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "quay.io/vaultwarden/server";
  imageDigest = "sha256:d89a6d21e361254670c24a4272b4b5f245e402c284f2f55de2c379fdbcfa1fa5";
  hash = "sha256-BEfPBJOqxMlycYnkFqBmPAoXvgSlx77yglK79NvG9GY=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
