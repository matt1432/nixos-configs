pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:c15da6c91de8d2f436196f3a768483ad32c258ed4e1beb3d367a27ed67253e66";
  hash = "sha256-SRR76LnvDjAc7rZCmyGbfq84nsYvAixk0mwFA4QkNh4=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
