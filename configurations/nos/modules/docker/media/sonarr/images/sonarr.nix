pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:aa566541ea012f41dd0eedc8bbc67910456713b750d1ace663950ce934269036";
  hash = "sha256-BD49AKXvqbqI/xx35VWx8mZ03Jvk1Af8T9I52AHoQ1c=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
