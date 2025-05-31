pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/postgres";
  imageDigest = "sha256:b8a840254e8e2db8720db3700a104623da372056347e80b598f00dd4da8df568";
  hash = "sha256-3AFzVH/zX+Ge3Q+Y7rZ9P5B7ZlNlAqy8pHsd2h26Bqo=";
  finalImageName = imageName;
  finalImageTag = "14-vectorchord0.3.0-pgvectors0.2.0";
}
