pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:9cea5b5c817379690bb5c53cd14bbf21fec44d39870d56a1d9e003f27a642509";
  hash = "sha256-+fG0prQjEv1XU5CguamD37REtsQ9QSqSDD+fCToJgTM=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
