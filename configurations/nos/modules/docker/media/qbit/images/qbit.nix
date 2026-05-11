pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/qbittorrent";
  imageDigest = "sha256:2e0148428b6769e2ee1eb6781246b6fca4b70cd680edfcb16e7113d9d6cb1631";
  hash = "sha256-OTpjIHdaBVIUMs/DY6EoZoBIDFzoSsEBrEF6jPLUawg=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
