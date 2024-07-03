pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nginx";
  imageDigest = "sha256:67682bda769fae1ccf5183192b8daf37b64cae99c6c3302650f6f8bf5f0f95df";
  sha256 = "17l0zpn8f8s25dwqkbm9ak9xbkz5czpfsnwvhdm7ykq52kxpxs5x";
  finalImageName = "nginx";
  finalImageTag = "latest";
}
