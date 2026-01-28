pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:8ef47cb3d2582a664062404e8e578c5339a8df7f5df82ea1f1446c7b5d8cef15";
  hash = "sha256-BzZBnm2x55M/QOXWo/ZAYgynbpUlyPdHcWL0rqW8hVQ=";
  finalImageName = imageName;
  finalImageTag = "16-alpine";
}
