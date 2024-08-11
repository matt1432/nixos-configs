pkgs:
pkgs.dockerTools.pullImage {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:4a7ccb015ded6bcde686a6d6340b5dbad2ec296a6653b42ec91998bb66259272";
  sha256 = "03ad0nxldys7ffk1klz1y5xh5fwgx6iqap1g9jbrhsl2i23hah10";
  finalImageName = "rssbridge/rss-bridge";
  finalImageTag = "latest";
}
