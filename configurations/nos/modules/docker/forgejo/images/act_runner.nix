pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:a452f8b6163523e7cbc09e12781fde57fb40b346af841ec0b5b6b34ad182ba10";
  hash = "sha256-7aleMeHVjgVTENS+TLEGqLTzXNnwC/54lvXokuZ3jOA=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
