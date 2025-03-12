pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "docker.io/fallenbagel/jellyseerr";
  imageDigest = "sha256:92dc0eb9ba260a11886ac52c3a82c5490769238f120e6312a2793809842021a6";
  hash = "sha256-eSVWRoXd5CzCRvgIfS8apt3SatF2nM3u0HEh9q52WXE=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
