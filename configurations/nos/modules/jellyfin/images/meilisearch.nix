pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:9cde2774864e6c19cdd09fcd2950bc01ac9a0454b6f343fffafa14faae6eb7ea";
  hash = "sha256-SxuUYNRLHKN0Qspiv7vEVQ79oeMDcPCCb+eQagkG10Q=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
