pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:6fb83511c0dca70a400fde79cb45ed59c4f66ea30dcba8c6f9274f01d77e5aef";
  sha256 = "05vyjlbrmcsrdz0gjqaxd8wgkch3hrq7dq740qzyqi8xlfxbiq62";
  finalImageName = "ghcr.io/linuxserver/bazarr";
  finalImageTag = "latest";
}
