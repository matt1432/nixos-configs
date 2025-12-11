pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "hrfee/jfa-go";
  imageDigest = "sha256:f09aeef980ea43d0912f673270bd302709346ee56c532f1d5b28aa06d2293787";
  hash = "sha256-r8/lZL2qrGL6F8az8IX43VCs/H4x+wwSFkyKbG018S0=";
  finalImageName = imageName;
  finalImageTag = "unstable";
}
