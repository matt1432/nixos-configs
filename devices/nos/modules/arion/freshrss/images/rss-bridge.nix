pkgs:
pkgs.dockerTools.pullImage {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:1fcc034dddc09ce8162601476d8960d58ad860a7b550d38eb95583cfc2fa3178";
  sha256 = "1gg41hinxxqspzl1iqwrz4fwd2qy080av15bfddjp32q7f3zsfzn";
  finalImageName = "rssbridge/rss-bridge";
  finalImageTag = "latest";
}
