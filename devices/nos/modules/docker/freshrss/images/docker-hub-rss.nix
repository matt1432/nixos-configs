pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "theconnman/docker-hub-rss";
  imageDigest = "sha256:7a6dd3f09dd9a3ad4ec3b6cf83ceb3fb11f15fd8df8b480a851e974ee0ff8e26";
  sha256 = "012cy2yqir36kpxb5jlyvsssm419bwrs4w7y8hz4nawvx69d1w69";
  finalImageName = imageName;
  finalImageTag = "latest";
}
