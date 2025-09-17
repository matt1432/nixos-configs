pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:856c93bab72a6a41a23ff60bab48554135c044a456f40909307011dea8ddeafb";
  hash = "sha256-7RVWg9DkSRml7psYb0aN1VAsdccl/0UeXFM3sqeCFkk=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
