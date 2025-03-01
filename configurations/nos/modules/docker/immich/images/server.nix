pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:3306cbb62e5ac5fd1449b0a92990686b6795afa7bed7fd9aec8fb81c978dec91";
  hash = "sha256-DU7fcDTvzZ7D6Hvew52wFUow8Vl9mDkwNbmYNL1OsMc=";
  finalImageName = imageName;
  finalImageTag = "release";
}
