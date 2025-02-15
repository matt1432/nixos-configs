pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:d109db5b37e26a803e3163e152f6ea5ccd8d6a3bdb3d076c8c99dabe171cb090";
  hash = "sha256-1DAZgUlF+VuyDjqWwBL134d8X3xYELVY+IBnk9CRElU=";
  finalImageName = imageName;
  finalImageTag = "15-alpine";
}
