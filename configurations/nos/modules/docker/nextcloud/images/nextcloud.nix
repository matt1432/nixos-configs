pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:d1de7e1dbf220587855e90b8658152ce4f028a84e36995186bb7c548b59cadde";
  hash = "sha256-+CF9iDXR0ykkPHvGpiDUylNnPQXdUvGam+R+loiHC7M=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
