pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:328d322af2bb8d7211a9c43a26ff5e658ba3e6f47a695e8fb9ff806bfeab0f04";
  hash = "sha256-K95lOcLWQLtvB15sSEALvd78cU/fTUfggISERk56kco=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
