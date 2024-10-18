pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "docker.io/fallenbagel/jellyseerr";
  imageDigest = "sha256:8ff28894f9fd28bf36626fb98ddd0ee79d778de22a5dc75d69a845281e19115b";
  sha256 = "01q9bx0arpxqn7npxsyqkgzs0jvnbzq5kiz1y6wwn0g5hl0jcb8p";
  finalImageName = imageName;
  finalImageTag = "latest";
}
