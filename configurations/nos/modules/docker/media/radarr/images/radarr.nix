pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:06f209efdfb25df8eaa6c275f6106d0a9e6b2c8502bd6dde3f95683c2a66aac1";
  hash = "sha256-2IjveFayx3DZ5CGTRpYoU66i6RkaOeoNzgbZArIpmLc=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
