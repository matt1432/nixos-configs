pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/seerr-team/seerr";
  imageDigest = "sha256:c92d2dc117f62185e7bcb88cd56efd374ea79210eaf433275449e8d5988eb5a8";
  hash = "sha256-6KKOVvnJrxKAZbAcgab+TTn/kblh85KP6dUQugFih8c=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
