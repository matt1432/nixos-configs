pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:23523a442aadf9298412e4336776d88bf8fd428308f52b8e6bd52a1542345251";
  hash = "sha256-QakK54EsFkjpH4pZviiaAnFvRh9i521xbloZa7Y4sN4=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
