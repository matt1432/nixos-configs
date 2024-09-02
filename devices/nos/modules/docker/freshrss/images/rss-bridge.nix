pkgs:
pkgs.dockerTools.pullImage {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:a4e973ca2c1967d4dae52bfd0694aa38e547c1f3e0c52553d0789ad4d55e6423";
  sha256 = "1w6ysakdf5wvbppcx1asa7bay0y2bv0hbrszwrnwgn59ivnj4iva";
  finalImageName = "rssbridge/rss-bridge";
  finalImageTag = "latest";
}
