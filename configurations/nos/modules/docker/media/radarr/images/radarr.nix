pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:e633fc93b9e2cea959853d27c6acc1d0b2d1ed7db4a800f6f46fe5b217f13102";
  hash = "sha256-CcUwDtI9gKPA5krZK7X6CEA86yspDndSwGRrS/NIfV4=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
