pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:c916ebd227c19c1dbe81f2cd594678c7bf6f07ef2d34b3e2f12816d205261109";
  hash = "sha256-7kJQ+393WHOJ5x0a7TNvFx12lKTygMLn8MBr8++kKUA=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
