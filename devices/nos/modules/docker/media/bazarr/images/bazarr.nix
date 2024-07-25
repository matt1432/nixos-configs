pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:25f0d19ba9226fdf15aec0fc7fa134ba89fc6f77f09d7bd45b33c5960c47821e";
  sha256 = "0q21k8msilcyknwad58zdmz9zrwwiy2gd6a5k4mzz5i6x0fr61fc";
  finalImageName = "ghcr.io/linuxserver/bazarr";
  finalImageTag = "latest";
}
