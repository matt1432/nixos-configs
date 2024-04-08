pkgs:
pkgs.dockerTools.pullImage {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:b543b93acf3c5e5f011b940352032aabc98221716fed57b4c7f902908731beae";
  sha256 = "1lk5x15dlgcyly0in9xhn7ibxp9hp2h65x9q3axhqiz28dkd176a";
  finalImageName = "rssbridge/rss-bridge";
  finalImageTag = "latest";
}
