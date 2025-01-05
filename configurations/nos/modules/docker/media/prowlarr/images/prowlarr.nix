pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:1f235ff7a178444398a9a431a4e65704d22f83a348192dececf75811212c9217";
  hash = "sha256-HLhmfxaJ4uvEz0XU+oVKJ7hqgnkst40nRCy8tXH1K8A=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
