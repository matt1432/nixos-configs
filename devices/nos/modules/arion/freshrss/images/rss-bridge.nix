pkgs:
pkgs.dockerTools.pullImage {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:c93da4448b02e3546bfd4dc09fbe5b5debba8f30de54dad723ed5b84683133a0";
  sha256 = "0vn2b6jnpdc1p5hqm27y3kkj441sadxd31w4b1pflalki0hi2ndp";
  finalImageName = "rssbridge/rss-bridge";
  finalImageTag = "latest";
}
