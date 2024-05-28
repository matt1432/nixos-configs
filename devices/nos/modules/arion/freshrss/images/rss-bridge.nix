pkgs:
pkgs.dockerTools.pullImage {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:82f85e977af60b5e241d8e63346d02c14dd325d932624dac7e5b6d2266f0214d";
  sha256 = "1qkhm7qqs4kjy4n1v1cv53s2jwac43b4c14ddwxpd7cydfbsvd8a";
  finalImageName = "rssbridge/rss-bridge";
  finalImageTag = "latest";
}
