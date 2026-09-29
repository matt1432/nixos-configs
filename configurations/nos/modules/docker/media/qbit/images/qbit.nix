pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/qbittorrent";
  imageDigest = "sha256:b522f9f4b769f8f36d49d22d5eb6a92e9aa18904c6a1830b1439df511ec21983";
  hash = "sha256-dHWpXghY7M6N71IpLNW06fHIADiYEtvGw3hjb38d2Fc=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
