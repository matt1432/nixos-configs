pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:a7c897a0b011b031c5f825e1667a6de4793c15adc53300f8ba4170d12a68d913";
  sha256 = "1di6avyffyx52wa2zdpgspvxsghqpgzsriq3x8dv2vh9rbps9h2i";
  finalImageName = imageName;
  finalImageTag = "release";
}
