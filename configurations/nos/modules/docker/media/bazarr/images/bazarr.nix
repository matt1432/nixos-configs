pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:f9cb78eaec1d77017f5c3e5b7aa07106fe4433a77fd902d01e91213f7c991499";
  hash = "sha256-FGdrIrErKSVzctzNRAQRmHsctdTTji79Vnn1whmFZUE=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
