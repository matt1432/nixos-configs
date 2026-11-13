pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:9600db22be3fcbf3d506176d3a73dd70a65c5719d9aa1d2837355b75afb8f4fb";
  hash = "sha256-WfhSkin1R7Qb+rv4EVDZ0r/q4oYsU20AM4zOeBV2hTM=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
