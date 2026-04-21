pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:33ee3a3d6f8335df010d4e79afb854d08f7f3429df6c9d92a194b37bd21a0751";
  hash = "sha256-65p+rDRkbrTeQc+3RU0BV5o9CiNoy74QM7O6Z6o1v6o=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
