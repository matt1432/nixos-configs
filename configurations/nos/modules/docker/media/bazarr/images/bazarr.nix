pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:e0c5d45965242830c5eeddaafe9ae2b5e8ca3f6c01ecda9ee9364f550921dc50";
  hash = "sha256-3mGPWIAHaRxA0ayVIkIp/rXHHghWNRoeK6pxxoUVvtU=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
