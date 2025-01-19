pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "21hsmw/flaresolverr";
  imageDigest = "sha256:3d99be35f845750adba3b9aa23844b7f585eeac6b1b45157bf14aaa8f7d16e20";
  hash = "sha256-ggQ9Z01xBegTwnr/8fp9mN140ds5ZO5Lk1yWhCbJ1TQ=";
  finalImageName = imageName;
  finalImageTag = "nodriver";
}
