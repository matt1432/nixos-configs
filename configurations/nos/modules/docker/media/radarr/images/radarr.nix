pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:adb6c09d6b729ea5e642c99cea35af72702ef476bf4763f153299ac5db9f0b4f";
  hash = "sha256-y5rw8DyJxH3aoEz/Lrq4xbhatau6bqNu4ysLCP+wG1s=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
