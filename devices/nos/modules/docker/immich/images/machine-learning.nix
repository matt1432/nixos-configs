pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:4d39300ab04824c8b3f693c4c7e4efed31e1465aa79c2fc4d7f2122c4fa62461";
  sha256 = "095m27nk0hzsxn57i9rhjjyh81r3psaq0i53d0pa9a9x7yrkp5la";
  finalImageName = imageName;
  finalImageTag = "release";
}
