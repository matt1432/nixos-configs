pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:da785b43f43e4f718c525d71453d6b7011db98c68434f02315cb7ee1ecc88889";
  sha256 = "0zd27m1gwiw2n2dslv1mxvi54p5gbgfilib99i7f8vh3sf0z7dcd";
  finalImageName = imageName;
  finalImageTag = "latest";
}
