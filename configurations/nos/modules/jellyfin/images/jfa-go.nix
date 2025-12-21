pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "hrfee/jfa-go";
  imageDigest = "sha256:ed94cdaff2e857ae276246b14a59eaa8dc6dbfc45cbabe2e537e1f33bb9b9ed5";
  hash = "sha256-A3s7EBTnT1H/xpw1jd4+nhNrpQLl2TwQ/4z5nz8P6BA=";
  finalImageName = imageName;
  finalImageTag = "unstable";
}
