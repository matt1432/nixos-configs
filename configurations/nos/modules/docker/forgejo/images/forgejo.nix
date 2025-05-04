pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:53d3a4ec77f79fcf8f71b959fdf9fc59235a1dc8e064f5acd24edb0cc8b70325";
  hash = "sha256-1ueS/UOEy0N7dYZf7b+GEY+2q6yugv3omzY2cDjpzMo=";
  finalImageName = imageName;
  finalImageTag = "11";
}
