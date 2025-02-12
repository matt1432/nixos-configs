pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:0989db1266d91e553375289571b989d49e10690d466802fcf23326f16b747d4c";
  hash = "sha256-0ZyQQS/GsPBzeCXhqvVgbBf4YUI8l3NPLe6ne61ZvC8=";
  finalImageName = imageName;
  finalImageTag = "release";
}
