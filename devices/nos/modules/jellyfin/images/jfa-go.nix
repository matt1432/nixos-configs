pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "hrfee/jfa-go";
  imageDigest = "sha256:958d926bd245b6a6a11155f02f04b3d3e05130cc1da98290a68fa5d911fe2f0f";
  sha256 = "07a8g77lqan6aga7yc8yjhp05blh9l4a44avc2c29z9wg6y19wfa";
  finalImageName = imageName;
  finalImageTag = "unstable";
}
