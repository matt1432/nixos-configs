pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:e1f05f60dada5f7bc83c52037e222a34c26ad04339c22ea685de680ddcd58487";
  hash = "sha256-YkNuTOt6msxCCRbiMrunNtZPjxYw2EUO2ZY9IIXS+Uc=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
