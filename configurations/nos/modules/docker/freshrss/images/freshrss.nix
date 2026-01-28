pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "freshrss/freshrss";
  imageDigest = "sha256:9100f649f5c946f589f54cdb9be7a65996528f48f691ef90eb262a0e06e5a522";
  hash = "sha256-3Cxu/0VP+tTQkt+66gJZIgvtuEaA5yLNVa13eYcKfqY=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
