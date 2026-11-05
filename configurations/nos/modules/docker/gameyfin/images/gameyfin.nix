pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/gameyfin/gameyfin";
  imageDigest = "sha256:c0c94f348c0cee5a72cf4fbf13b25ea37d2533360d4009a97d2693c17e19c138";
  hash = "sha256-rf9jcmxEBaq/5BGqm44Qru4WFl/YmRG0Nv7g7j6ry6U=";
  finalImageName = imageName;
  finalImageTag = "2";
}
