pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:99b6c15a1bc98e623103a83a04023662a93fd035dac4f0a856d781afa9d71095";
  hash = "sha256-QRs4/j9sAWTeSfA8vTm7eSVZBEsFMT34UEu/7RtriL4=";
  finalImageName = imageName;
  finalImageTag = "10";
}
