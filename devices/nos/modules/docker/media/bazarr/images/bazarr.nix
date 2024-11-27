pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:5805d6a44689a41cf78a8317208276a52f0647fb3cd0b2c4a3c8df6e02f93d3b";
  sha256 = "14gb5rw8vvrrlyx6v0sl4jciy5560rd89bf973aw5rfw1jn6ks6h";
  finalImageName = imageName;
  finalImageTag = "latest";
}
