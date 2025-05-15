pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:85718606c75bc0924921cb2df05b0f81c8a691952d44a5bc9f9946254493d1b4";
  hash = "sha256-OGR0zlxmwNH240tCowKx3Xpx1nVSyMj1rn+TTt/lH3g=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
