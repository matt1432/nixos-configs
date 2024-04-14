pkgs:
pkgs.dockerTools.pullImage {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:f3954569a1d276f910cbfa54f7cfbe80e32b291c243f1ca06d176c678f9468e7";
  sha256 = "1d66h8m5z9n83fqmiymqjqxgkvh2ch8w6zmnrj2way1l9lvh8z3g";
  finalImageName = "rssbridge/rss-bridge";
  finalImageTag = "latest";
}
