pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/calibre";
  imageDigest = "sha256:ebfeb487977b5ffa7698b424b83002868521b65734d149aa4bf36e268709de2a";
  sha256 = "0lvf6jf48anryrw6ns76g7xgvaab9bwh2d9xplaq6522dkz958vg";
  finalImageName = "ghcr.io/linuxserver/calibre";
  finalImageTag = "latest";
}
