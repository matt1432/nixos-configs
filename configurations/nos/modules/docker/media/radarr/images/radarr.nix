pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:6f1dda18354ea7f28cead8f6d099fc8222498c3ae165f567d504ed04d70980d7";
  hash = "sha256-xKwKouCGvqfppDx0ocbxrL4DOM2Kq9Boyk3qDvmBH5k=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
