pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:b238e1bc3d13408460fff7924dd5e5999573bd4006e25b8c211a5f6c289d01b0";
  hash = "sha256-RTVaFFTct9FDJ/z0QCW4TKm+TfuR9QdQuFWUa3YVRlI=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
