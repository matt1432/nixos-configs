pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "hrfee/jfa-go";
  imageDigest = "sha256:0a11f320de0e95dfba0d249fb742464582341ef2da9095945d7ed0f55fc49ebe";
  hash = "sha256-VlDG/nd/6PrlgXNc6H1tztYyBLQwTF0VDlm14aLyhqc=";
  finalImageName = imageName;
  finalImageTag = "unstable";
}
