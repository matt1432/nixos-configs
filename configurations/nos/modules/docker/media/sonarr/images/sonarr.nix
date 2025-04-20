pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:cefa1c97ba8f5db60c1c89d04015ead764d3b850b4fbdc5784bdde2a02d72350";
  hash = "sha256-Agmq0CND7zhmahKWriv1m3+XmSP7nvRPg5YBBOmINXc=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
