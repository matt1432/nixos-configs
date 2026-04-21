pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:e13a16ddc45f66fd065b3416230c2669426cfa8907f4a43f14a9c09a17691fa4";
  hash = "sha256-JHf0pbMj+9SwubxlfxhblWIzd2aWO2q2XxXF0eoHCvA=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
