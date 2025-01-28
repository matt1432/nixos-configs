pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:07e45e10be9539f04dd3a819286b5b308b08142eeff7bc58a89bf21d97237d55";
  hash = "sha256-1Yc69wdpEg823zlNfXq8tHc9IUW0yjr2YAJ99MIK0nI=";
  finalImageName = imageName;
  finalImageTag = "release";
}
