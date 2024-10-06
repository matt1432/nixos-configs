pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sabnzbd";
  imageDigest = "sha256:a33738b946bee3bd2a754b2e576643d069ac2913d88290ef13d8e00f0c0e1224";
  sha256 = "0zvfd75brjqkrpnqrg2gk9z3l0dn4d78x4iqzhm3gc9v1a03rp25";
  finalImageName = imageName;
  finalImageTag = "latest";
}
