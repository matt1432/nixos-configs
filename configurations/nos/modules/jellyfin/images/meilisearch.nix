pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:f7ff0ec7ef2fff985ab79082674d7008fcb74219eb6b2aeb4af14d0591ed1e82";
  hash = "sha256-SEljZJeCecyz4O6FtpZRGMVEYqiLBOn/UBkBJXyV9XU=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
