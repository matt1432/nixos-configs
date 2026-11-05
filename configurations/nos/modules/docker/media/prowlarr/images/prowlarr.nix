pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:431d7efebcef466e56adaa40a7a2fa2b0e85159a037b8bf465eaadbf0cf5bedf";
  hash = "sha256-OXIWARwrtAJqcw8wSP+2W8mWDsXgiDf7fiAwhztovoA=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
