pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sabnzbd";
  imageDigest = "sha256:ff682bedd109c45dbad25ab8edcc4f3b837b9ac48c39751fbbb33a858eab97d0";
  sha256 = "01a2k5jv0vi82fg1vfm5x2rplx34sxgswvpglba5v45b8yis4rgf";
  finalImageName = imageName;
  finalImageTag = "latest";
}
