pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:8286638680f0a38a7cb380be64ed77d1d1cfe6d0e0b843f64bff92b24289078d";
  hash = "sha256-f4rzE/Cc60xSvSjJLlBAsNF76UvzA1CJ59wEJDkg32U=";
  finalImageName = imageName;
  finalImageTag = "release";
}
