pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "netdaemon/netdaemon5";
  imageDigest = "sha256:5acac9a6f9dca0d8eab178ee211a73e03b3cf9fa2c8deecf45afce33f57d2011";
  hash = "sha256-IjRyb/6uAzPKu0pMFDxXBkZt2rTG43rXQx2SnmPXptI=";
  finalImageName = imageName;
  finalImageTag = "24.52.0";
}
