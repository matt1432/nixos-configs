pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "docker";
  imageDigest = "sha256:3f3c01aaaebf7cce837356b688b7c059a4749f10bd7660dec7c58fc454a283f0";
  hash = "sha256-D1yPLBAAuYdjYss8dHgbx1iAnpSKWBd9lwJLBXjG9z0=";
  finalImageName = imageName;
  finalImageTag = "dind";
}
