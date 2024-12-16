pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:fb197595ebe76b9c0c14ab68159fd3c08bd067ec62300583543f0ebda353b5be";
  sha256 = "1r9hjizmsfc1h6b8cb34qdaanxqhkzw2rqhamx38k8a2bx9w1m7x";
  finalImageName = imageName;
  finalImageTag = "latest";
}
