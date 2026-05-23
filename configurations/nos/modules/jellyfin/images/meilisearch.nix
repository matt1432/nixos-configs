pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:b839a48d008d4e67e57f78dcff5b21d5e8b8fa066bacd11f97824d6307abb0dd";
  hash = "sha256-yovieAgroeUGjOi3szxALRJ4W3XmR0JINvmfSeLm4a0=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
