pkgs:
pkgs.dockerTools.pullImage {
  imageName = "postgres";
  imageDigest = "sha256:20e49432a20e1a63bb985977c32ec8f110bc609b93de35ad4f19c5486abcefaa";
  sha256 = "0jxkjj726jb1hal4j1vyhnrmbpyrkvawq5nf3dpiad8h3zamvk66";
  finalImageName = "postgres";
  finalImageTag = "14.2-alpine";
}
