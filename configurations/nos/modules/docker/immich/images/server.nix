pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:f8d06a32b1b2a81053d78e40bf8e35236b9faefb5c3903ce9ca8712c9ed78445";
  hash = "sha256-Syr08DUPgQskAyDhyAUPYLLp6OxMLxr1g5p8MRKIwrA=";
  finalImageName = imageName;
  finalImageTag = "release";
}
