pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:9f4ad6df544ff568838315aa12743a465f3ac10a9a63a41b2e8c1aaaf5360820";
  sha256 = "0i9x90zxcrf8gf5wj056vkq6156i7n4fz1z58c94dc8nzqs4zls1";
  finalImageName = imageName;
  finalImageTag = "latest";
}
