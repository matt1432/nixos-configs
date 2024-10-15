pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:1eb7b45d222d49d33acfeae0ca612e64e838bde1bd142830b6160e358edef815";
  sha256 = "1a64bywipy5znsjwfkshs00fck7v07pzpnfqgri261x740pdck7p";
  finalImageName = imageName;
  finalImageTag = "release";
}
