pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:4c41e2d0a3a55b325ed572cd0200bdb72af1433c3daa2bca6ef8eea68ce504a2";
  hash = "sha256-6p+BwBx4xI+pHGl/sLROzQq80qxOgNXHBnn0Udy6FUw=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
