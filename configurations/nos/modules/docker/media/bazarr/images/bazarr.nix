pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:a93c3595410f5c5791a126d7705cd8a29f3ce882338eef304cb8bece3ef2580b";
  hash = "sha256-uN7cpvDHcm+ASpk3/R/TB01xSZsa9S3i9QdSpj+oqZQ=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
