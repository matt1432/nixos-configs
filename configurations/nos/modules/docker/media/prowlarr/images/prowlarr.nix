pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:d3e9307b320b6772749a2cf8fc2712e9e824c4930b034680ad4d08a9e2f25884";
  hash = "sha256-Wl6F4JkDwtHx3kCtiQabAKUnmGr9X83KfsHjeD3Z00I=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
