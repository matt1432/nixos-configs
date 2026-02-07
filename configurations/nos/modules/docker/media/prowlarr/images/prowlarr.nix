pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:5339e9050cfcc0cb5331e9c98610ed9d4ce70ef481a5461ea664a13dda3f1eb0";
  hash = "sha256-L++ZiuO/Ox6lasLa60Cd0gs+WQtTKSCaoazh3hk+8Wc=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
