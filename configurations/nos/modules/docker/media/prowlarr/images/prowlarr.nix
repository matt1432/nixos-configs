pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:126ead562b0fb1716e5c07db1df81f96351ae4de07b0101423cbc9317ccf012d";
  hash = "sha256-aepPCv7CQKGMK0qjoDM1UXHFUGzXXhbpY+sDXT+gmq8=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
