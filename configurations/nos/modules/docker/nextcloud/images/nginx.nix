pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:1beed3ca46acebe9d3fb62e9067f03d05d5bfa97a00f30938a0a3580563272ad";
  hash = "sha256-uH9UPRsaiFb2UNI62Y1VOlwaRANYJKGkOIXj2QZ8JPg=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
