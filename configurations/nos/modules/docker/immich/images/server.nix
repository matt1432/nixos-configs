pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:073fc04c7e3d18ace466c20763809cf17aa55765ed610f12971b392a6a80b50c";
  hash = "sha256-a7gjJS0PYEn376PnUavSzKkvmlvykCItdrjP5F2Jcks=";
  finalImageName = imageName;
  finalImageTag = "release";
}
