pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "qmcgaw/gluetun";
  imageDigest = "sha256:2733bb22b27e3efa7a9f2cef9057ec12791b8b225793fcd3dbfd0508404dfc25";
  hash = "sha256-Mr0hS6oMbRda0IhwCCdTBbB9tikjkKE/8hhXujaX7H4=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
