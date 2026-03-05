pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/amruthpillai/reactive-resume";
  imageDigest = "sha256:e46c9a3e8cb05addcee3a7599b6bed77b665292b89dd35c5d1030cf7150e4d24";
  hash = "sha256-FMb+4CJUtOqD/N7hPj/ClCfvRt1OP1JsZanBHBzC9DQ=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
