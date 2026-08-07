pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:2f439458ab6a57a925825ae14f9d06910e4fe4a41c8d4a0ae06397e65b707e1b";
  hash = "sha256-84XLLVkGneT/4UcDHla4FI36o4B/JcRO+Z6XKxMTmik=";
  finalImageName = imageName;
  finalImageTag = "14";
}
