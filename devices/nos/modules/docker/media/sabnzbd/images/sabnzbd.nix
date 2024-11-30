pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sabnzbd";
  imageDigest = "sha256:1d31c01bb765cfbbe916b418b336223b07541e50065e6b4284f5ffb8ea452d12";
  sha256 = "1xbhz80gdwv32pgq265jqi3qh6ab6drn9nc07jfwrnbvxjki3nvk";
  finalImageName = imageName;
  finalImageTag = "latest";
}
