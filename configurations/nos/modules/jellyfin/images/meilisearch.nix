pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:448a5b1b3e9303fabf39b84a2672f184295f665b1cb8eaffb11c738273430e5e";
  hash = "sha256-cq5AhsKNNVkflOkK6gbTm7cwhuL9SVopGUwbKv/SBIA=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
