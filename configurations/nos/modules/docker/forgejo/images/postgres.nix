pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:d508bf6220b5c7b7cd9c735d6abd5ea2e6e4e45882a29ed704f625aba32bd935";
  hash = "sha256-KPLxy0UPHNwNF09tMM/u+abgtuio/m2OH4zRN8MVw08=";
  finalImageName = imageName;
  finalImageTag = "14";
}
