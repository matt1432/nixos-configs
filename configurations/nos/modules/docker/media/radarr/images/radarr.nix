pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:ade5937813c6ae415b29db729386e53fea3ecf067a019849bafbe2d2a6ec02ba";
  hash = "sha256-reNcL3T7ixt8zibmdIwIGgjGxJ7aWnshEK7O+3IpR/s=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
