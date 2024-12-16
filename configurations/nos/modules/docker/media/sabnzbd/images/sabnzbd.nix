pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sabnzbd";
  imageDigest = "sha256:d0e307ed7ddbda9c93872f02fed402d538aab52b2605e71a2f80c26f5ba8d3c7";
  sha256 = "0v28vvlzr4acjbfpwh3vqm08lhk8k4v6qyxjbac2wsczkcvpqwck";
  finalImageName = imageName;
  finalImageTag = "latest";
}
