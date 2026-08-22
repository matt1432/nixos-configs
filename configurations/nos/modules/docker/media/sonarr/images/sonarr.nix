pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:c19aa4ecdf03d73e1d5c901da33744cb7eb4d921f89bafed1ca264601d7fa224";
  hash = "sha256-QOnJ9i98zFLklfaf+PJWP5eP7WShGeCV0+2MES0Kg2I=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
