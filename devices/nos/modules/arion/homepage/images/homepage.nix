pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/gethomepage/homepage";
  imageDigest = "sha256:0f066a6d6fba3a810a85aa79a483302b0fee21139b67adaeb245edae5051f3e8";
  sha256 = "1isj9xai2m723g1m6ma2x8g11j6cb8g9jpvrlg3z6m8jhdnn33d7";
  finalImageName = "ghcr.io/gethomepage/homepage";
  finalImageTag = "latest";
}
