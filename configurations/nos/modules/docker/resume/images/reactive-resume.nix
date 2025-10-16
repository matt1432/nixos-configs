pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "amruthpillai/reactive-resume";
  imageDigest = "sha256:20b9e30c53bc9e8af1762f3d675ac470f871b3e9933d00f830cb2a13008e641e";
  hash = "sha256-v69pntWFWN2sdN/V+WyRa0p4J/0cT3ae1fyDUNgHYoE=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
