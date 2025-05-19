pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:adf00838f50ffaa0cbd211f8a8bb247a67adf28a3bae8839b855d0489e4594a6";
  hash = "sha256-XaOfpKDtpVRio4s86KZf0AXb3I0wFy14a+X7P+ZYRE8=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
