pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "freshrss/freshrss";
  imageDigest = "sha256:cca8988d05cd449e1c6c69405971b1e6fc2c2116ceeb45c9fa3fc33837997a75";
  hash = "sha256-QXfO5m1t05bedBohfPsm3qZ66cBCqRysBIBMHBna8q0=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
