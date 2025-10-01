pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:94443ed9374755752e2ecb2d0133759b7c7e828a2393cc6a3eeadf08c8f3875f";
  hash = "sha256-DDtjezpE+EqDwapcooQtXhNW55q1h4yAGUAOKTbXWn8=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
