pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:d317916b28090c33eb36b308464ea391f8b7df1d850fcfea227a39ec879718c2";
  hash = "sha256-UDGii3D0jlhrwe9BgXExWiCYMDaRiib1WDtXnKPE8i4=";
  finalImageName = imageName;
  finalImageTag = "release";
}
