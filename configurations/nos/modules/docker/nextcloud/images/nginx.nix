pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:cb5f00c62327e777ed141ab7485e7b258dd4141e86831cecfd202467b7b22743";
  hash = "sha256-8EmanY6du+j5WTPire5ofrlkTLR3hqmydBHWS22oiOs=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
