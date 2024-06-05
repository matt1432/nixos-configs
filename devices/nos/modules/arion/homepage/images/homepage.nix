pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/gethomepage/homepage";
  imageDigest = "sha256:840da91bbec48e009524c0e66616c5dbbfce4497d3c387687c668a956975d6dd";
  sha256 = "0r84ys25dv9dsgi7nbzs3pxc8gclgikdarkywl3am0w5qcmcnfp2";
  finalImageName = "ghcr.io/gethomepage/homepage";
  finalImageTag = "latest";
}
