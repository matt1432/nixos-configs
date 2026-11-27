pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "bilde2910/hauk";
  imageDigest = "sha256:560ad5af315fe2c8d4bc13947504bfa4ffb05fcc8d7305da2c0c9d90939635b4";
  sha256 = "0dx7g8hrm4gz5bwd2v12l0hvyvbwrf9yiyqsn1pvw62ii8j721zp";
  finalImageName = imageName;
  finalImageTag = "latest";
}
