pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:3acdca3bb6492f5ad4c7f248b4a140febfd3a180c9706cff21abdd39688d365d";
  hash = "sha256-qrb6LEKdtXVI4bmvPunRw/vIuKpXk1Fv3LPYjqaqz4s=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
