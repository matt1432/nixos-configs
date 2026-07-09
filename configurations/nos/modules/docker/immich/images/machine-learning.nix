pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:412f68e46e1966d0f87a8733a430369ee184b3a83e7b1e2db536dff291a34aa7";
  hash = "sha256-3GE11LTTzQWRfeqsG5AYvAwSA7hwUIeyScwNsT/6YXQ=";
  finalImageName = imageName;
  finalImageTag = "release";
}
