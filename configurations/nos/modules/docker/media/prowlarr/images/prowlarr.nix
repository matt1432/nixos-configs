pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:e64cb6fe480d68615cbec57b9c717fafb321676f360575b332990fc6251a386c";
  hash = "sha256-EaHiGLn8V33JIt9wTF1uuwZOsSI+A/4osmsgFPhtITE=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
