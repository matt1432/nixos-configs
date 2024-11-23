pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:1b8494bb9fe2194f2dc72c4d6b0104e16718f50e8772d54ade57909770816ad1";
  sha256 = "12l0h6yjj53sqfjm7ik4ss87lsjlb85xkrj7l25pkcfgm5i8qqdx";
  finalImageName = imageName;
  finalImageTag = "release";
}
