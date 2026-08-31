pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/amruthpillai/reactive-resume";
  imageDigest = "sha256:27d682727ebd96c68fdc50d8e49c717ebbf3797e8e311e0b8ed2c5b35dc663f5";
  hash = "sha256-l9cyRFIEyxubkspV6e343hEY9qgidOegxkF1eARQbE4=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
