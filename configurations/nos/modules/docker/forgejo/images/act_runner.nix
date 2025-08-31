pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:06e4b98c3c8f28d4891d59a1deb8c1189830ecfa9ea49dc4013f0dabae1258c7";
  hash = "sha256-kzLr0GidymQq8MwDgXMhVr6/teelnankrHIHS2BfeFg=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
