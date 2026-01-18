pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:d59b504313ef3107d9f2e8ce04dd133b4c78218810174a1b2592c1232b0aa888";
  hash = "sha256-OM7sIwSH+zvolNF7tUkQLlfXTREE0HYgV2UfLFYA6Ds=";
  finalImageName = imageName;
  finalImageTag = "14";
}
