pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:72a9b9de6c6abfa7a9c9cdc244ae4d2bd9fea2ae00997f194cbd10aca72ea210";
  hash = "sha256-q+Mi0MroILoNhPIGAyWtpw+OYZfU2AkY8AMuxQbTIDg=";
  finalImageName = imageName;
  finalImageTag = "release";
}
