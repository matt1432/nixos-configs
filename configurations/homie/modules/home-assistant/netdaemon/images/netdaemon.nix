pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "netdaemon/netdaemon5";
  imageDigest = "sha256:f1685239cd48f3d728f393d86975f954a954e2f64bad197cb534a66fafaddd55";
  hash = "sha256-KF6QLKuO8O2jE70dOprE8lfCnXvbhfk2XYp76pGXujE=";
  finalImageName = imageName;
  finalImageTag = "25.14.0";
}
