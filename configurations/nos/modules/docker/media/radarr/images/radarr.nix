pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:1184ee84bc5329c4f62c070a04d73eaf7918878410ca48a1f3dbf82b684eee27";
  hash = "sha256-3NY5WaqMsNIxtMDzBsR2j3iVZ1K6lKEFVoCZZTj8mvk=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
