pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:9de8e139d3583793a9b707c90efca9a1a66298ffe202b73903ad218e412ddef9";
  sha256 = "0jp68bm96sfniih6r7mj17z3ds70zqg8i4wxh0f6mh8snp6cwwz4";
  finalImageName = imageName;
  finalImageTag = "latest";
}
