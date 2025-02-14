pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:35816840281aa2fa2d5630d981ce32c72388f5e885d9ea1be43b38c76ab95d42";
  hash = "sha256-v2IAVcXSDipzLGZAOFEB2zXjbTf5F5EdMQAcdg1tiIM=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
