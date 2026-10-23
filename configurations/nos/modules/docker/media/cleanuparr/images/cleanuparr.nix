pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/cleanuparr/cleanuparr";
  imageDigest = "sha256:d0212e4c66bd0522e23c5e5da5d3006bd5ff0e0de1e3ecfcf892e039d55721e2";
  hash = "sha256-YrxVy5/KFRnjmZsSpeyKicqWH2tAHVkayowu+PaGkDY=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
