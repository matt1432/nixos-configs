pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "onlyoffice/documentserver";
  imageDigest = "sha256:9c76330ee4be00623e204c5305b20f8868c37e0e90c88e351c27feb148aada80";
  hash = "sha256-8fSmxhmYKlSCxWxm27ARuEUuExzrQp+oy1lZ9oul+us=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
