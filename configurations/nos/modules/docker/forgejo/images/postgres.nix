pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:c0aab7962b283cf24a0defa5d0d59777f5045a7be59905f21ba81a20b1a110c9";
  hash = "sha256-ReNaoKpVe2Cc/lK5qijIkW5X11BbwR77XqmR/AE7hpg=";
  finalImageName = imageName;
  finalImageTag = "14";
}
