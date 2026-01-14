pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:2f00e0eddfad1f7a32a1e73fd8873654c1e6a979913a8cfcb5fefae102ed0f68";
  hash = "sha256-KPLxy0UPHNwNF09tMM/u+abgtuio/m2OH4zRN8MVw08=";
  finalImageName = imageName;
  finalImageTag = "14";
}
