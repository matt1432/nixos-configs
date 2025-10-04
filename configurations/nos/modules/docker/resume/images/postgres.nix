pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:52af010baaeb34a287e7b5ea9696720727bd5bace64f9c18068ee187a6d6a4b2";
  hash = "sha256-yF8cwPRNFfJy+dCOfs6eFC9aV0e3buwbwFWrJcBmJLo=";
  finalImageName = imageName;
  finalImageTag = "15-alpine";
}
