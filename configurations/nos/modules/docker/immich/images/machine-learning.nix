pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:45626a33361ef7ed361de41b0d2dc19e5949442cdf0a8eb64b157dc8a04e9855";
  hash = "sha256-d2o/U+yvvbNew9lwjmQ8bco9tJuT/dvNB/nlTZUweUU=";
  finalImageName = imageName;
  finalImageTag = "release";
}
