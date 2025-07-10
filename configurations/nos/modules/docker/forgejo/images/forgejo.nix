pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:e2684fd8707d486329084a695ed91999a4072a798e5409d45c1eb8a2911ff4b9";
  hash = "sha256-4BVxQ/oApvmGhSfp4faK1ktQHp5XuaCVUpFJNekvdPQ=";
  finalImageName = imageName;
  finalImageTag = "11";
}
