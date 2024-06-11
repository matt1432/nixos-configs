pkgs:
pkgs.dockerTools.pullImage {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:f4beaf19862378b16bea1555bee0faf87b93d1d1da433527c2e70acf618c1ffc";
  sha256 = "1addixf0wwh7fl012c278qr16sbhfzcd6zk7pn20735bpibpf4b5";
  finalImageName = "rssbridge/rss-bridge";
  finalImageTag = "latest";
}
