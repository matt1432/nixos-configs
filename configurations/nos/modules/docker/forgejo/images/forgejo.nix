pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:bff07e43f5c84449e9dc6dca2c0a16c6f9eb285405d7f1bc631a360fd963f3fc";
  hash = "sha256-fdxqzoIvsn9rVeRGulc6PF0WpgO8WainRt3Da2aYshw=";
  finalImageName = imageName;
  finalImageTag = "15";
}
