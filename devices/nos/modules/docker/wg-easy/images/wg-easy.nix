pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/wg-easy/wg-easy";
  imageDigest = "sha256:66352ccb4b5095992550aa567df5118a5152b6ed31be34b0a8e118a3c3a35bf5";
  sha256 = "0m41f39a68rmhv0k7fbxib7g42zpn06sgrv1iwzc6n946ad440al";
  finalImageName = "ghcr.io/wg-easy/wg-easy";
  finalImageTag = "latest";
}
