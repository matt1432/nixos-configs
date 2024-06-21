pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/sabnzbd";
  imageDigest = "sha256:4fb40ea724abc25cf9496cdbc8e528aa0882132737e49c5e712c264284fa7b94";
  sha256 = "0nwi79hryq8w5iq94ypyp5iywq94sa8cprnxiy67d7i6fs2a3mdd";
  finalImageName = "ghcr.io/linuxserver/sabnzbd";
  finalImageTag = "latest";
}
