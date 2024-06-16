pkgs:
pkgs.dockerTools.pullImage {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:e21675968e9b9518fc83ba023a1acb38d013997de9013cf2a49d811c7bab567f";
  sha256 = "0zy957yzrpzaxf9spwdhql5f340cxaak96rg8lyn1yvln3zi76cx";
  finalImageName = "rssbridge/rss-bridge";
  finalImageTag = "latest";
}
