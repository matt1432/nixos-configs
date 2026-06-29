pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/amruthpillai/reactive-resume";
  imageDigest = "sha256:c5791a55eadfbd5fa3995b8b9e07c58082f238f86b2a077723f37a8b7f4e2f84";
  hash = "sha256-FrlHYeQT24ggaaESGh87bvpgQDwIWYQMW27epvoF6aQ=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
