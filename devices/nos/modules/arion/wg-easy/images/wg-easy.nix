pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/wg-easy/wg-easy";
  imageDigest = "sha256:f810dc71ef86192c2c43350d21505ca9c855ec1d62de8f52439e4dc2095181d6";
  sha256 = "0rni7ha0fpyd3dp4gykrk68lf6b1nvlfwdgbp0n8r9myl9fw9r7b";
  finalImageName = "ghcr.io/wg-easy/wg-easy";
  finalImageTag = "latest";
}
