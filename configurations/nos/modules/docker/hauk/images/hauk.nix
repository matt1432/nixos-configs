pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "bilde2910/hauk";
  imageDigest = "sha256:d8f45559490a12fa8e689716a307d70496b1b9b6aa772d135bd2b27d5bb79ed5";
  sha256 = "0dx7g8hrm4gz5bwd2v12l0hvyvbwrf9yiyqsn1pvw62ii8j721zp";
  finalImageName = imageName;
  finalImageTag = "latest";
}
