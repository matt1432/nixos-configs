pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:0a5d8d75f026342a56e1065613e565ec40a05f4042dc7fead1dcfd66d539fef3";
  sha256 = "13442jn0dnpbpfp3902dsw7s7cq6drp8xdza8msw403i58hc9dh6";
  finalImageName = imageName;
  finalImageTag = "release";
}
