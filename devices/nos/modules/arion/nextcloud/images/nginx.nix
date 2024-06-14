pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nginx";
  imageDigest = "sha256:0acaab7c2237e052dc5adf1694ebce0b374063a62b2a1b7f2b3bc9cd3fb8c1ff";
  sha256 = "099ivwfqsb1d8svj1kxy2bnvr8zwf4sgw4816dkghsb4jqnij270";
  finalImageName = "nginx";
  finalImageTag = "latest";
}
