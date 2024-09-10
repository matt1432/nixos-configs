pkgs:
pkgs.dockerTools.pullImage {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:833fa82afded7dd01514807009ccf66983bc21d874fc6acbe057a1fcda0f5e2d";
  sha256 = "04gi7xn6335anaf908p3znc4d6llfv8yv4n7lc30mfxn7fh3nns9";
  finalImageName = "rssbridge/rss-bridge";
  finalImageTag = "latest";
}
