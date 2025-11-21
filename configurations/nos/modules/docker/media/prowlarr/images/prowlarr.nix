pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:3dd3a316f60ea4e6714863286549a6ccaf0b8cf4efe5578ce3fe0e85475cb1cf";
  hash = "sha256-29qwxSUXrxSu6XWMoJcZYZv5dtC1xqK5WWRX/UTiCfQ=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
