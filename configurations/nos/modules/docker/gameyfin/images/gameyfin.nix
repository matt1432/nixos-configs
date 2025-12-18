pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/gameyfin/gameyfin";
  imageDigest = "sha256:dcf228761a22db7852ae2e2d142c99d64eb84ca64d18fad9349dc7a9c1f81650";
  hash = "sha256-wsxPm0fxzfhJb/M1oKlD2EAZ481O3Lwtl6RKtlKkECY=";
  finalImageName = imageName;
  finalImageTag = "2";
}
