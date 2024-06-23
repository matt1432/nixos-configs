pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nginx";
  imageDigest = "sha256:9c367186df9a6b18c6735357b8eb7f407347e84aea09beb184961cb83543d46e";
  sha256 = "1rrq5dc62skmnc85hqfp5rk18iz20f8vkcr2zhrslrp8rmyy5gg5";
  finalImageName = "nginx";
  finalImageTag = "latest";
}
