pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:aa7fe8eec3130742d07498dac7e02baa2d32a903573810ba95ed11f155c7eac1";
  hash = "sha256-OpTt6zhROgfbzULw9osaPJFwXb1nqoReDgoYbG81+tg=";
  finalImageName = imageName;
  finalImageTag = "release";
}
