pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:36226b305613cdde76ee8da89a66e8a8b4fb4ef4b673bdb7b9a9d25efa14e047";
  hash = "sha256-BeNQfuvE6P6SIeUfk6KrldEX5WW2I0gIvQzrt7a6dew=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
