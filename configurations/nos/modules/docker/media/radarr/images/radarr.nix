pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:f174546a0ad7eb9a9170e4142bef6f74ef3ebfe6209528fded40630369406dc0";
  hash = "sha256-Dnh9aJSnLVu2dhf4K95Qb2t7sLuEr/SHsRh1fHViYkc=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
