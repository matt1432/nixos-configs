pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:cdf5eb3cfa207d46b066bfbb41b03576c67a1f6ecc8aba19146d0f7349ec79dc";
  hash = "sha256-PtMnisCS1Tim/yqL+ZvAeuSCA0VUFkdhKJVqWCccOa8=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
