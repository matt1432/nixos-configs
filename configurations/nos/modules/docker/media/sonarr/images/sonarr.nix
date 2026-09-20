pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:a5c1a5fecbef946927ab90ad68df319ac5fe644057e5fc18cd993f01ac07b2b2";
  hash = "sha256-obVnV//Vxk3PKzADYXx0QYrQaurw0o15OEj1hxmyaNI=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
