pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:39da107b5a9371fdaa651bd188049b863716a815385eb3a30d41071b7e1aeb33";
  hash = "sha256-NfZAmBOMfY1KAp2UU3i+TPlwCu8SqMS6VCnVWciz8Ww=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
