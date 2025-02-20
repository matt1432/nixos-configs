pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:33a605960120eff07b4713f094a4588ce048e8e3aa7a1599f41224cb67122ba5";
  hash = "sha256-taaXiz840PVct6naG6FC8UV5gY6sw82DpGqeKad1HWI=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
