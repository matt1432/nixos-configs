pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/qbittorrent";
  imageDigest = "sha256:3679a75dd2304b695525d83a4ff14c458708b5da4a7ce53044240932139590e1";
  hash = "sha256-IgGCwQYp1kr1P3CBmo7q3gYhwUExkhCXI/nZMnCmMOQ=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
