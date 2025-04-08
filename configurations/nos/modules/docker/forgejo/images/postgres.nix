pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:1e6c52c366e39e869184256c45757e1c85ba15b3d244b0a2cea640da6df1c4e3";
  hash = "sha256-w31u8URnr3jhPCHDQufnzn8AMPIx9zQ8ICMApHep6lA=";
  finalImageName = imageName;
  finalImageTag = "14";
}
