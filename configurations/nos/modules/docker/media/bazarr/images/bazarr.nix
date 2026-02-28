pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:b0bc617664dbca25845ac3b1bb6411b145b6a44a6d173071c9d2f426524fdd9f";
  hash = "sha256-L/nonFyRB7jBuYNtOcBfHqFs5xDOadABYAxpV7j7OYs=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
