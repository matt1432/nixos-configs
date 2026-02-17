pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:37be832b78548e3f55f69c45b50e3b14d18df1b6def2a4994258217e67efb1a1";
  hash = "sha256-nwjc7WZy2G5g0KWS0xZaFw4wZ9vRmWw87l5lQPWLvro=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
