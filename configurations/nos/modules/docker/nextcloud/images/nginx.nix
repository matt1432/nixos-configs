pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:7150b3a39203cb5bee612ff4a9d18774f8c7caf6399d6e8985e97e28eb751c18";
  hash = "sha256-GI3ujp1mzUOIUZyoFH113v2lHdRjDISq6qLRLjS60jc=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
