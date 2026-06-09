pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:f0001b47d029a61bc894a2547fbf306ce08ecce6dc5555c26b8afe7f2e518c4a";
  hash = "sha256-Cp9Acjxh8YMg+/hPSRdDTjhimxVdPbdB+zO4lbL3LL8=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
