pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:8c106fde572fb799217dcacb01b6f869af693322069bc134dbd6341d0c175abd";
  hash = "sha256-np1w6YUYauS7LEOSYbC+02AxNrp4jpVW86EJ/YUQksQ=";
  finalImageName = imageName;
  finalImageTag = "14";
}
