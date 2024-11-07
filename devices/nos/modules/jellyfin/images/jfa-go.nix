pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "hrfee/jfa-go";
  imageDigest = "sha256:739977423a29f65811d50d1bb98571db38da109e2f6f2d2dc4384092d009cacc";
  sha256 = "07dcxwqgkk2kb2mr3pvmabbmry39sw03dqymzhs9gws489w4wzcm";
  finalImageName = imageName;
  finalImageTag = "unstable";
}
