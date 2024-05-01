pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/calibre";
  imageDigest = "sha256:1175ad34511e6c8e82d7ce882123623433013bc2da9dee1c7d1c518996394443";
  sha256 = "0k2pgsg9b305lkyr1rzpaav8x080iyh2kcnhzv5969f0fd9d3mkf";
  finalImageName = "ghcr.io/linuxserver/calibre";
  finalImageTag = "latest";
}
