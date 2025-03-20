pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:3a4631ca14c26674ef8f4bdb9a8d0eb20ad39bda6f05801e6c7abb452c324c66";
  hash = "sha256-rKON5tD5cr/NR6rmdPyWxqVQwvOK7JpEkPVIJDxT20E=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
