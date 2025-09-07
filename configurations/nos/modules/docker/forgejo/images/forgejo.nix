pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:3a56af1224a98370204efc317b56f1384c3fe0ff22eaddf9204eedffe283a67b";
  hash = "sha256-EAn0hJ+L0LpZQDubbGRp8ErXtpwTzVeIvL/Gwv+SKPQ=";
  finalImageName = imageName;
  finalImageTag = "12";
}
