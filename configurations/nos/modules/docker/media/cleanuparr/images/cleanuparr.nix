pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/cleanuparr/cleanuparr";
  imageDigest = "sha256:4dc51e05385778a43daee44f1ed481392f10fbf94fcba0db0e7ad04a97d3a8b8";
  hash = "sha256-GXM1JbxAEITD82uOL9eJPENuPn9TVU1EFjSr+yzOhlk=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
