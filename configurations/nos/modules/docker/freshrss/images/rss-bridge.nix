pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:7205e8e30f233d684b91c3dbfa23aa16a4626044729007784c2eeb3e7f85738c";
  hash = "sha256-sQJcrTeIOd3qvxJCVS/3LzX3pOe3FEbB6BfEVbNq1Lo=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
