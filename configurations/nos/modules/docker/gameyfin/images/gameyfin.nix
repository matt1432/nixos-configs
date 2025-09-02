pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "grimsi/gameyfin";
  imageDigest = "sha256:8997e5b7eb1a565dccbbd3d9b37655d0da87a9290f1a0e8084789aa3dabc7ced";
  hash = "sha256-4haFg+FBCrc7eMTcxNDDUKT4TVGpzm103lLDvAaDDsI=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
