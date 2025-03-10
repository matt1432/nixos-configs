pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:620189d67078ddcfeb7a4efa424eb62f827ef734ef1e56980768bf8efd73782a";
  hash = "sha256-YofT547ZYsqIjw955xIzhREOPqMxoK1gNPDLCU//XjE=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
