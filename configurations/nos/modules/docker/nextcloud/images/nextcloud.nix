pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:dbb18d92bca7d6af2343c40aaffab42973401d906c5cb9f70e16dbf7c85a967c";
  hash = "sha256-R5mbGhy04q/IMzAb/AX6pfun4XBuNOVcEn9jDkNtAu0=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
