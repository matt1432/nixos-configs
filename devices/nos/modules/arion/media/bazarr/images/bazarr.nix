pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:a17e094ccdf0b252415c7307167e08fac4ee01809eda3b02a3a9e719f395e664";
  sha256 = "182lhs2cqcikizzjd6x23k55mdgvbccwb5yahzclkh5cvd31y4l0";
  finalImageName = "ghcr.io/linuxserver/bazarr";
  finalImageTag = "latest";
}
