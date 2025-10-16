pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:750251d7dcf245d05ad6b2b0c39685282df43a8582875fa31ab2a9328af64e26";
  hash = "sha256-/dIqwniPkTAT0+Jw/XSnxFDk7LQCdlHKkgyKb+USB/0=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
