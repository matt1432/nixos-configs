pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:3a884925eb3001c8ff577bd4ef156d6a606ad01d36ef2daddef8c4775e943187";
  hash = "sha256-uH5wQozRTQeV+Jr35F7Bfq5WKQBipaO0wQoRFH5TimY=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
