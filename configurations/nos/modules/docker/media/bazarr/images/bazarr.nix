pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:7adfe3ede9ce3562098a6f944fb644da16bdf245220e707260f89f1507c87b54";
  hash = "sha256-sajAOHzMd7sKNYOJv9BT3rNjyV0uo2W951g9cCxpwnU=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
