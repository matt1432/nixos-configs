pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:4b025354d338999e03bf6dbdadcdde94815d39d4a5aba5de3cdc86a56d7d6c51";
  hash = "sha256-gu4fcoayii5tj09PFsGpm7gYtUe6Hn0vHW0WBmObGJI=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
