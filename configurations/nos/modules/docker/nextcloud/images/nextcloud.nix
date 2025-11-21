pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:ee7afc44d26f977abe1448e3779e66934fd137f3f0f92cd51593167e08372b0f";
  hash = "sha256-EZJ5REA1hcK4t88LBDCYhU97HhntZgD28wa3BUs3h44=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
