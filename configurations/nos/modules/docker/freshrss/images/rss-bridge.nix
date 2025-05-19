pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:9e02ef33361b130d7d5ea0738c0a23d10209a42b3c372aaf8ed69be6d928de39";
  hash = "sha256-OsxTMtI6eQsUJPHhmdpfyG91UNxE2xhnGoD5qVhjdi0=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
