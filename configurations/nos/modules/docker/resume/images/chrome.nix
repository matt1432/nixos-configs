pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "chromedp/headless-shell";
  imageDigest = "sha256:2d349b544a1ea6b5b5fd7c0fe99215ff662339c57407ee2e8c0a11af93516b04";
  hash = "sha256-XJTzrBBzSu43ZuD5sOO5gVOrpfJZVaOPu2JyKyfLocs=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
