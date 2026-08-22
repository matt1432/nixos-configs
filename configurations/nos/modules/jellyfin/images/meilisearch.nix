pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:8d6643d86d71fad6ad3cba92cde7ccfce9e4d6c384bda67598eb553571c32431";
  hash = "sha256-9EduxWK1hqIxYFuSWF3jWyN7wSVAIkWIu2WM4fmeaBs=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
