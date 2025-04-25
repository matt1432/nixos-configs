pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:48fc9c8315a00e1856cb9dff1db626ec8c7f1e424d60a6002c7f04ce94fdfa9a";
  hash = "sha256-ZTsAMlqByJFznaZH+bvYD2qtjG811q+J2r2l78/eaa0=";
  finalImageName = imageName;
  finalImageTag = "release";
}
