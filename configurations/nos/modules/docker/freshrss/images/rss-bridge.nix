pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:698ef67309d5fe699cc8e3064f7a1440cba4e4b8bf8a472b99e00c357d95e25c";
  hash = "sha256-K1+H4b9dZfuyeTBVUv0gLypqzq7uL6foUaJoyzjzkIU=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
