pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sabnzbd";
  imageDigest = "sha256:5f323d7c2c67f700f8c0e40f25bf3d67c03c35b65c82a1c1680fcb0d055f6528";
  hash = "sha256-9W577EUXEXl3apN3o2Z8ZfvisS3Qh2JD//kTixgJczY=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
