pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:1156329d544b38bd1483add75c9b72c559f20e1ca043fd2d6376c2589d38951f";
  hash = "sha256-CtgBcK9ubDEiFCBWdHHv+13/VIIXR18WjSHaVfiekMc=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
