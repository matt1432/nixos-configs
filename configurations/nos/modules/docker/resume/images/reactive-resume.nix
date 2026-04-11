pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/amruthpillai/reactive-resume";
  imageDigest = "sha256:27bfbf77ca8c5f990f66d6d5f76e665c5cd127c6b018871769e3cf4b5c053d17";
  hash = "sha256-WHqDcbHjPlMZS0foq37mQkDaXlXy5Q/uHQuZf9Vf08Y=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
