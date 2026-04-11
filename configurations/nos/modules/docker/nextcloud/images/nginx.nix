pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:7f0adca1fc6c29c8dc49a2e90037a10ba20dc266baaed0988e9fb4d0d8b85ba0";
  hash = "sha256-8EmanY6du+j5WTPire5ofrlkTLR3hqmydBHWS22oiOs=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
