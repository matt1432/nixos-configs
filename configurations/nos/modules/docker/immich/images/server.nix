pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:de80b21948fc3ec4c96872c24bf3ea556a8d9b5bfc3e83445e0094b605282761";
  hash = "sha256-0RhsCWCijZZoZe3ny2cAXsV9VJh+6gskAa9AiNbyKts=";
  finalImageName = imageName;
  finalImageTag = "release";
}
