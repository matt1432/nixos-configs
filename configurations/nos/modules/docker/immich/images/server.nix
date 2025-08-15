pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:12cee930e2cc211a95acae12ad780c0b2eecaea0479a06e255c73a4deb0b3efb";
  hash = "sha256-ueshYCRlOdwZZU6dAbyRjq69W9FNHIqhayYQGFqdjfA=";
  finalImageName = imageName;
  finalImageTag = "release";
}
