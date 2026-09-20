pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:d24bd0048c759a468970989e9df11a6b96a7628d556d00f923e60a35ba59237b";
  hash = "sha256-wxlcDj/vRrYKFtFEWFynJf3ZIvOQY9oe04Pp8+7oCUs=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
