pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:09d0cc9d18048f8084334c139690a2ffcf9598879bf436946521941d077c10d5";
  hash = "sha256-6L8x+lx70dMxuWU31lBTQB6aPnzDb3rWLefwXBkvUFo=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
