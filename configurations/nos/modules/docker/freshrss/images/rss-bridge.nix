pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:1a2d15dca385612eb8e07a8ad823140e39cbaad7c68ae8571c8fad437085bc0e";
  hash = "sha256-cpj9NtswvXc3LSZSjZLsjouDuAEipSa99uQYgftocpU=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
