pkgs:
pkgs.dockerTools.pullImage {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:57946d41a67bfadf8cdffcd0a188ea67aada5e87492d15a4fba80c21ca1a05e3";
  sha256 = "166vjpj3npmy65lgp8gchspkrm9k346mz1qgvmcn1p5gsblar57n";
  finalImageName = "rssbridge/rss-bridge";
  finalImageTag = "latest";
}
