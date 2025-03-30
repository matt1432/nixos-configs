pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:32235ce605d88a9d7dd881565286f358e657f6556b2c6ddc797c7ffbb717b432";
  hash = "sha256-xycBYYZp++1mNxiVuKxOB8mk4ZqUaHgiVDJHtMNxFGg=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
