pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/qbittorrent";
  imageDigest = "sha256:715d2bfbcf1cd3d734cbbd4fbd599eb7ea0642eaa079a372dd0d343f59516700";
  hash = "sha256-165jOCVQzZ5d5LFsZ4JZSbqeOCeUoz7I1tzJo9GBttQ=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
