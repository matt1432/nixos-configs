pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:a59e984fd90b9dee0c872cdb9183d330d71c038d7a3b35def5ca3ae7fb186fb2";
  hash = "sha256-alhhZHznMpLRpwq2mMuuSrUH5LfEpV3mgfaV6+RPRts=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
