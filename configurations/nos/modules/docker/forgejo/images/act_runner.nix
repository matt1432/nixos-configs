pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:05d5d57b0333f8d80ba8f561eaa99b10eb2bd9c2f5a4f0aa2dc28a5d5151f071";
  hash = "sha256-0TmTdx5bzdDyl9xL3a9ezIfXJ5XaFMhrs9MuDlu/oEk=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
