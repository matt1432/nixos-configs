pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:532749cc71739130720c9d1cd8b8fbec204f6c8bd94fd633fccb4b566a672a55";
  hash = "sha256-+4Hz2f2Lv6XC48crGfUESG7GpVsVkQkO7XWVyeyeZGo=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
