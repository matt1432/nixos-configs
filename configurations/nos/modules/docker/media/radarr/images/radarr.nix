pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:c8a55bd83672d3b63dc20edf325277ce7dc3b69d4400568cc5bbc9e6a227ebf4";
  hash = "sha256-QMSwytrQ2fw9xnKBSoWUXX3cuhWINVRMyRq0PBv2Epw=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
