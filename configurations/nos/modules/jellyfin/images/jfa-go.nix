pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "hrfee/jfa-go";
  imageDigest = "sha256:69a438dd99e9c27f006f702c39f2d359357e435a6d2b5d3b51b8a4f5dc28a080";
  hash = "sha256-RYw1KxedfNEklpwRtvqVPno48RIBTgtCicg+qMYQT7o=";
  finalImageName = imageName;
  finalImageTag = "unstable";
}
