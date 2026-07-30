pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "chromedp/headless-shell";
  imageDigest = "sha256:dabddca3d1b3d95f0004bd16c62e581b701e313b41cce1e36606db1bbac06db2";
  hash = "sha256-UofaTHM5/02HPuMEciyE4L7qrUH8vEF9aSB3r29k2qA=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
