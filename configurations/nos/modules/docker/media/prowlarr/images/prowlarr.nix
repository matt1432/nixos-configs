pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:2489c6dbaf11e3a6d71aeb2e6980d04193d4af611aa7064a974851222fd41722";
  hash = "sha256-0PF0eLXpl6UhL8OFcQatOaFcJZiWvQyyCWNXyLgPqdo=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
