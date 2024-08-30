pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:aa904c142512b64e98b0abd038bf8b07e1b0e8cf3a14a805cb9ae4df9415b933";
  sha256 = "1cxvjcmc1q55i2qz33hqnrgyqxj3bm37pwql4yzycri09bqiz3l3";
  finalImageName = "ghcr.io/linuxserver/bazarr";
  finalImageTag = "latest";
}
