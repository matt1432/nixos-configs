pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:1fcf0e22f76e55241a57a48e301d935852caecfa94b5164da760be278ea4aadb";
  hash = "sha256-rRb21uiYZfseDL64U1+LHUqXGPRNPMPtxtaVgqOVgQg=";
  finalImageName = imageName;
  finalImageTag = "13";
}
