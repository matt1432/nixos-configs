pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/sabnzbd";
  imageDigest = "sha256:6c25ce4614035d6e25736a2fc30a7087b95f4dbae64933eb113a8e2f081bea4a";
  sha256 = "1pz9kdn963x7vhqa0s0vp7y90racfy7cw9lidnxlhd5w957f00sq";
  finalImageName = "ghcr.io/linuxserver/sabnzbd";
  finalImageTag = "latest";
}
