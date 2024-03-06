pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:d5e469ec1723869dc5bcbbaf66134e629df0569fbf42fd7c9858602edab90230";
  sha256 = "08yx3axaifdm60csk4jgmi6cpfkw2m7ppcjz2b8hqvd5j5jsx62g";
  finalImageName = "ghcr.io/linuxserver/prowlarr";
  finalImageTag = "latest";
}
