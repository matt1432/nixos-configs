pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:9530eb044660a1847e68ba9f39f90499dae0db83c3bed088973771c5f3f30007";
  hash = "sha256-gKJ94twADRrGJhdy0mSEz5R3cEFFZ5ACZrhIBetmeOc=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
