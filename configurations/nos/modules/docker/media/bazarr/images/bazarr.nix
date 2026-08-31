pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:3a820372f19fcb2981ea19fe4b5382934d67414afaba974bce831ddda0a64a02";
  hash = "sha256-6wS2vCPNHLGsYyET+ko8Hg/TJOBX+GIa2UQSom1SjOY=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
