pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:4ba3bfa985b911129b449734bbf63749a03f6ef69b8ca37f2ecd74d46fabef1f";
  sha256 = "10apdbqsma7yliny5cj6hjz813g1bkdsazdsd95nxnx2f299ks1f";
  finalImageName = imageName;
  finalImageTag = "latest";
}
