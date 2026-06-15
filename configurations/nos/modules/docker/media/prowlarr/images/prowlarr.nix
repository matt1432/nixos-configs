pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:a46d0ce0a8236bc4e065fe7c91a55d026c9d849620c5845250519b977d8857f3";
  hash = "sha256-6Juvtx0ZZhQ52HwtSHL3PWIxf9QbdKBUwoiOnwPEjp4=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
