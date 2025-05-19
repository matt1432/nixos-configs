pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "hrfee/jfa-go";
  imageDigest = "sha256:ff68a8936bf88af7f4ea0c28e42908cb03a94d6d5952fa24a709bf7105a07155";
  hash = "sha256-LDZhSw8+y3fvbevgR7uZ5+CVnFHsQy2KKIe1tDQKqlU=";
  finalImageName = imageName;
  finalImageTag = "unstable";
}
