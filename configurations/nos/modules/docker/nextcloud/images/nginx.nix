pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:f5c017fb33c6db484545793ffb67db51cdd7daebee472104612f73a85063f889";
  hash = "sha256-f2vIWlVYnF6TQk8GZv7JTuO+0Isuvy0eeNBD0AKxO/w=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
