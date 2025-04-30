pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:4836bc848e0d55e582f56d03f0ea89ee03fc33585cf46484f16233151613fd47";
  hash = "sha256-xMykJYfS05i6YYQeUrsXbOHeMpmmRrYt0L5V2rZ+o6Y=";
  finalImageName = imageName;
  finalImageTag = "14";
}
