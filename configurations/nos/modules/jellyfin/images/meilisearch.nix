pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:9af2a48719a1afadbe932a35329ecb504d034234319150a8eaad8de85b621754";
  hash = "sha256-x9Qgs21CGK+xV3e8RmqZK6qjNoxIfAX1EkE+IRYc/yo=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
