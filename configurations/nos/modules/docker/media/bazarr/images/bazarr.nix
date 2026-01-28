pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:d6492cc79ca5e12fe617c7285e7ebd60d4e7f0e93ec7faa78338dba91f07a91e";
  hash = "sha256-5tCaJmEt/A4WE3hY2/EsyScAMKUxwx83fFOIlYs9h/E=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
