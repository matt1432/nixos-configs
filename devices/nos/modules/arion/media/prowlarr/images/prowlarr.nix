pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:c43dc0311d4381395b60b3a6068e82226eddb213278bfe886bebabe67eb0f762";
  sha256 = "0jnbf5vvjdyjl5mb76bg05hjqrabsvi4jczszi5sjx81fslz61qc";
  finalImageName = "ghcr.io/linuxserver/prowlarr";
  finalImageTag = "latest";
}
