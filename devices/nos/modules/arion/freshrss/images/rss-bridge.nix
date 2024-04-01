pkgs:
pkgs.dockerTools.pullImage {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:43589900367183b47443b1a8a5c5e03132cc1b59d16d80e8399354e768108790";
  sha256 = "18307nbsssn3gs21gmx9m94awdhmgj0d92az79nwnmy2y4mrkmi6";
  finalImageName = "rssbridge/rss-bridge";
  finalImageTag = "latest";
}
