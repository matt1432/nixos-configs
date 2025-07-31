pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:c0836f49c20000e603170dc95d74c2527e690d50309977d94fc171eaa49351a4";
  hash = "sha256-+ftNf75SXqmDBmW0uLJzidB1CntO1is8z7m6033jpoA=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
