pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:e87297f8ec332240228d24f2d6f0b408e30749f4ed166c1e5cf30a2288723794";
  hash = "sha256-NXclYlCOKf5N7lejK8dnAUH/nHLPqmlvgWKlQsHjPhw=";
  finalImageName = imageName;
  finalImageTag = "15";
}
