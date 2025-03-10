pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "docker.io/fallenbagel/jellyseerr";
  imageDigest = "sha256:ae1703c66b0fc12bfcc8cba339a77044246a93f86cc8ea53665e88b3218f111f";
  hash = "sha256-X5+RsWy0fQDbarvxHloZKkIzw6VtRUL7Axrcuv6jdB0=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
