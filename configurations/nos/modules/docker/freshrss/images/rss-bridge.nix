pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:c297fdc1e353fa0398d1a85939c83032bbf88530d281efc87c855afa55d9b9d6";
  hash = "sha256-6tpX2I5m+dF19sXFAzxzJzommZsB1tDyzMOC4z1ZSOk=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
