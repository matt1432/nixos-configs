pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:d6c430bc4bb48979dd8247816af75e4fbb5999535eef7c9515ba8e5dbc8ac80d";
  hash = "sha256-LO6uuTSHWzwbLFuvNrQ/qAf750cmkvZMCVDbIHzmeig=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
