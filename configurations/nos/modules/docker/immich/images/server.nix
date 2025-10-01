pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:f34203f6c2db130c26480ff21c412c6f0c37c24ee5261f6a6e4fe1eecaa921c0";
  hash = "sha256-H6liEOOqz975kYaQldEv5Ej6WHgCS9oh8JaVAvOFYc0=";
  finalImageName = imageName;
  finalImageTag = "release";
}
