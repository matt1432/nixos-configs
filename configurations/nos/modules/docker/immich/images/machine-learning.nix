pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:7c78ce7562246a5126d62bed9ba609f7129842a3f4c243b99e2dd68fb0ba43a7";
  hash = "sha256-BQwg89/FvEH1dbnRMm711ph4zzJjnxFtFgjZDWT2A0Q=";
  finalImageName = imageName;
  finalImageTag = "release";
}
