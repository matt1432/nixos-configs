pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:3a66e9805d74b9b2cd67c9bac37c7b5345ce85639922a550194bba4572d403cb";
  sha256 = "0jywmkf3amcz1n2ff3051kyhnnbkl2mxr6a5fq03y6sqah411gsb";
  finalImageName = "ghcr.io/linuxserver/bazarr";
  finalImageTag = "latest";
}
