pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:c0e14efd7eaf4d83e443b6e7047ddde6465edbbbcc28ae770d9f5398abba1969";
  hash = "sha256-iWs6RjAiqcMq0znGoVbTurLrSI3jFiCscBQqEfOdqzo=";
  finalImageName = imageName;
  finalImageTag = "14";
}
