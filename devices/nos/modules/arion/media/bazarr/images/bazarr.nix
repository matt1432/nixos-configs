pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:8981610a213d462a96700f833955194366a1224284e251cfdd33bf250c766179";
  sha256 = "081845na2a05mrv8qin10hdjaamkg1kmxs4xhf4ln6m2p8a0x4y0";
  finalImageName = "ghcr.io/linuxserver/bazarr";
  finalImageTag = "latest";
}
