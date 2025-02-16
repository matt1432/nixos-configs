pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:4bd44d9ac596285e113c44feb6f1e5e0c63c0121282dede187c9a5b9f8597efe";
  hash = "sha256-1DAZgUlF+VuyDjqWwBL134d8X3xYELVY+IBnk9CRElU=";
  finalImageName = imageName;
  finalImageTag = "15-alpine";
}
