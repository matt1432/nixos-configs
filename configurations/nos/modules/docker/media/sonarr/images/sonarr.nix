pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:6221d75e172247220c320bb340ce0ff96a09339216de52b8d861424bfc501cef";
  hash = "sha256-+fnvtqiXa/xxUiNp14eLjjd699zSBhx4G47iF401EGU=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
