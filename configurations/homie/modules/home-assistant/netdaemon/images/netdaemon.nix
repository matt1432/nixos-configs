pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "netdaemon/netdaemon5";
  imageDigest = "sha256:983727221f52dba8375b5e90fe5e4e660e88fa5f2fe67cdd1141c3c7643b5ba7";
  hash = "sha256-kf7fP7x0PUaMivcLNOZ+3oH3d+NrpyCy74N7nlshywU=";
  finalImageName = imageName;
  finalImageTag = "24.51.0";
}
