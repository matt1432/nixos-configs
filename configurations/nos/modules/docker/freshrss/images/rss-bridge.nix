pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:5dcd8d8d76dd8a68d4da97b16adaf09c1c90827181d2f032fecd59795d3c2962";
  hash = "sha256-tPsPhiQt9TVmFUapRQ6AfhaMMGGx8AZ+93lJbrmk3hQ=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
