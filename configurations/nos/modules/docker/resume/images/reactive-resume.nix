pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "amruthpillai/reactive-resume";
  imageDigest = "sha256:066eebd08b94de0042936334509244dcdec5ee438bf849cfcd52e51342a7cee0";
  hash = "sha256-SKK3lFgOgag+hS0Q0C4xJ5VviInIdFvtYPpVB0N/qb8=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
