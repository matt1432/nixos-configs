pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:943f7b4772e2c93eab2ad10ccd29946c62b69d3196f3dbafc70de77d36672cad";
  hash = "sha256-cFYxqBQGadM5BoFtqYzv+WiEXd6L4wYB9h811Ks5A88=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
