pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "chromedp/headless-shell";
  imageDigest = "sha256:47e3a0c0cbef29e321d16c893cd804996243f710ca7855770dd4f9c4cd2b8627";
  hash = "sha256-9T8+8rNlrOi8qNVP5kIbi+aar0Wbgmb6ZAwn/jCD8SU=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
