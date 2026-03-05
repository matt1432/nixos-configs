pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:94eee5e3e14430b7b144d4556be73963a7daf6f1bddc25586627f426465482ce";
  hash = "sha256-bE5vj5MsRiYTuRXtpoetprp/kVeE9ocOTyupAV7w+9A=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
