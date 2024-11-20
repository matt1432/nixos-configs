pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "quay.io/vaultwarden/server";
  imageDigest = "sha256:84015c9306cc58f4be8b09c1adc62cfc3b2648b1430e9c15901482f3d870bd14";
  sha256 = "1r6g9xz272iki08rnbl6ax2f4xw2rgm9xpswwgsk3qxqp23ci5qd";
  finalImageName = imageName;
  finalImageTag = "latest";
}
