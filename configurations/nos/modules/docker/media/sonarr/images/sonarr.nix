pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:f3a7fda30a0133b24b04857a21e7a81b97ed2722e147503a47ad0b4fbc7c7694";
  hash = "sha256-lnVanGnk3YSgBLmh0ytN62rnwrYIp0XLU2HIrqVKZmU=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
