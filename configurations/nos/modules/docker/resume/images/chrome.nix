pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "chromedp/headless-shell";
  imageDigest = "sha256:8b36bc4bca3f394103db8a2e60f0053969a277b3918abc39acfee819168c4f79";
  hash = "sha256-jK9s0ntohK8YK3/L+Ug8PYR0CBjy7Je0kvBonYBOBzs=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
