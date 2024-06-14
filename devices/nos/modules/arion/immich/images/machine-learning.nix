pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:9db20e5c2033bef01fa2be50fa0a2c3d62e43f069aedde4d49a65e65a436d40b";
  sha256 = "01cchdlp322nbw0rs6akcx569wbqf1lydwvq6zw9lpwkhrsyrrvx";
  finalImageName = "ghcr.io/immich-app/immich-machine-learning";
  finalImageTag = "v1.106.4";
}
