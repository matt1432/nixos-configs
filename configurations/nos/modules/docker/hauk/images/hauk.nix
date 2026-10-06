pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "bilde2910/hauk";
  imageDigest = "sha256:0cb80df07fe76e74988a5532d6632994eedaf74ca3ca81e213561e9b1f136c29";
  sha256 = "0dx7g8hrm4gz5bwd2v12l0hvyvbwrf9yiyqsn1pvw62ii8j721zp";
  finalImageName = imageName;
  finalImageTag = "latest";
}
