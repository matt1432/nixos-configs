pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:16a30c1ef7412f3781dc9635bd42798399601a9750f871cb68e5efb5545ce0f5";
  sha256 = "1lg7yakdvg7n9cyhqaf2ka4bj9a1902m6vbbkx1x9sx3igr4xlwy";
  finalImageName = "ghcr.io/linuxserver/bazarr";
  finalImageTag = "latest";
}
