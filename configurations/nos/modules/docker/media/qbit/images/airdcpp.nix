pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "gangefors/airdcpp-webclient";
  imageDigest = "sha256:ecbe4a970bfe373f6f273e60b6f8fc1369ea11a5b9f40e1c88fd58aa82d35f5f";
  hash = "sha256-Vc7JBHDyCq6EYZFNVbexRG/uauVUFhp8voJSm3SUJL8=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
