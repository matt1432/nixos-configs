pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:5c4e7a25a01e4dd52e9b919a277a2d870af0a08094e4089c85708e402512a8aa";
  sha256 = "096njvy8rncdifyjal69qx6k1yz92pp4vp6bcxzh4cfjdwia2dsr";
  finalImageName = imageName;
  finalImageTag = "release";
}
