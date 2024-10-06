pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/gethomepage/homepage";
  imageDigest = "sha256:671c2ed1a61b5dfbb9a1998c8738c3aeb1acf11adbc12563f81fcf4fd9802198";
  sha256 = "14pfbr0h19qwydvs3hscmsylg0z4hzg3m86hdpk6z4mi663mjra2";
  finalImageName = imageName;
  finalImageTag = "latest";
}
