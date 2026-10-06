pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "freshrss/freshrss";
  imageDigest = "sha256:48b63b9bc3d042a1301c32971b01af8841c7f059b452589c5bf77f475ba44c61";
  hash = "sha256-6tOss44hanER/nFuV9yzVHu+o/oA9EMBF29iYeJ9zco=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
