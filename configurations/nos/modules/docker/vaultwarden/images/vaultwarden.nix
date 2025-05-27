pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "quay.io/vaultwarden/server";
  imageDigest = "sha256:48267ea14d8649b2e553a5fe290c40b5dd94d54e9a24b26ae7134a75a659695f";
  hash = "sha256-t3grj/7iUu7kFjjM05bE86CDj4/8OdN7GEEo15ocoRQ=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
