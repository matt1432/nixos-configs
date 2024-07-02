pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nginx";
  imageDigest = "sha256:1aaa8180df68200fd41f9066cf62155e3b71183c04b2895a7388d5fd84ef3c8b";
  sha256 = "17l0zpn8f8s25dwqkbm9ak9xbkz5czpfsnwvhdm7ykq52kxpxs5x";
  finalImageName = "nginx";
  finalImageTag = "latest";
}
