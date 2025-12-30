pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:8186cfac504299f28d9cae925b703bba6c758f5648793a1b5fcd8d89f9569826";
  hash = "sha256-NMMBvTAISIuyN7IaqbJ2y/G68+hYa2imsUI3sSrtIb4=";
  finalImageName = imageName;
  finalImageTag = "14";
}
