pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:abab6e9054572fea9fd409cf0f4fe3b65f6c8e70cd0f213004592b6d0e9587ac";
  hash = "sha256-RLgBLMU2f4Tsh+lREUJHAHMx/B2iLZisPASrVl0iuA0=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
