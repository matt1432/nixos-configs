pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/cleanuparr/cleanuparr";
  imageDigest = "sha256:c7cd53ad559a67147637de3d825f66ef6e6a5498490b73f49c6e4d72f13bed76";
  hash = "sha256-UBHm5hy/SLt3jhIu53IPRW8z1iFgx3H9vpY5+NtTz+g=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
