pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:56d9958e2f81b05351bb40959870c25bb6400cb9786a58067ca303ef3233cf78";
  sha256 = "0sfvcp6x6la30m07sglvnkp8829fxwhaxlysbmmz5xrsnzrv9vkr";
  finalImageName = "ghcr.io/linuxserver/prowlarr";
  finalImageTag = "latest";
}
