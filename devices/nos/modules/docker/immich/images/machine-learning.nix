pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:e8c416445db60c0ec94394c1e0e672b78409664f17de78787c62f6d13d3f6d92";
  sha256 = "1c89p8p0nwbfnpci0yyin7kg7wr5699v27cnj574690nfw4wppnm";
  finalImageName = imageName;
  finalImageTag = "release";
}
