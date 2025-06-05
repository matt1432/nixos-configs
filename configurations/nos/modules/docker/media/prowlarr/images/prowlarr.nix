pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:68d16fa1a692ec26c4340a23f50b5980899c5630ce881fd0015dac849cbb9b53";
  hash = "sha256-X0U2bSKm4+zAEmhTwlr7F8jNhuXpBmZh2Jzj5ubuTmQ=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
